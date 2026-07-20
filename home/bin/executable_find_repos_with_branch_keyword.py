#!/usr/bin/env python3
import argparse
import concurrent.futures as cf
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Iterable, List, Tuple

GIT_LIST_BRANCHES_CMD = [
    "git",
    "for-each-ref",
    "--format=%(refname:short)",
    "refs/heads",
    "refs/remotes",
]

def is_git_repo(path: Path, timeout: float = 2.0) -> bool:
    """
    Detect a git repo (worktree or bare) using git plumbing.
    Faster shortcut: check .git exists, but rev-parse is more robust.
    """
    try:
        # If path isn't a dir, skip early
        if not path.is_dir():
            return False
        # Avoid obvious non-candidates quickly
        if not (path / ".git").exists():
            # Could still be bare; leave to rev-parse
            pass
        subprocess.run(
            ["git", "-C", str(path), "rev-parse", "--git-dir"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=timeout,
            check=True,
        )
        return True
    except Exception:
        return False

def list_all_branches(path: Path, timeout: float = 5.0) -> List[str]:
    """
    Return all local and remote branch names for the repo at 'path'.
    """
    try:
        out = subprocess.check_output(
            ["git", "-C", str(path), *GIT_LIST_BRANCHES_CMD[1:]],
            stderr=subprocess.DEVNULL,
            timeout=timeout,
            text=True,
        )
        branches = [line.strip() for line in out.splitlines() if line.strip()]
        return branches
    except subprocess.CalledProcessError:
        return []
    except subprocess.TimeoutExpired:
        return []

def match_keyword(branches: Iterable[str], keyword: str, case_sensitive: bool) -> bool:
    if not case_sensitive:
        kw = keyword.lower()
        return any(kw in b.lower() for b in branches)
    return any(keyword in b for b in branches)

def walk_dirs(root: Path, follow_symlinks: bool = False) -> Iterable[Path]:
    """
    Walk filesystem from root, yielding directories to probe as repos.
    If a directory is a git repo (contains .git or is bare), do not descend further.
    """
    SKIP_DIRS = {".venv", "venv", "node_modules", ".tox", ".mypy_cache", ".pytest_cache", "__pycache__"}
    for dirpath, dirnames, _ in os.walk(root, followlinks=follow_symlinks):
        p = Path(dirpath)
        # prune obvious skips
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]

        # yield this dir
        yield p

        # if this dir is a git repo, don't recurse further inside it
        if (p / ".git").exists() or is_git_repo(p):
            dirnames[:] = []  # clear child dirs so os.walk won’t descend

def scan_repo(path: Path, keyword: str, case_sensitive: bool, timeout_git: float) -> Tuple[Path, bool, List[str]]:
    """
    Return (path, matched, branches) for a single repo candidate.
    """
    if not is_git_repo(path):
        return (path, False, [])
    branches = list_all_branches(path, timeout=timeout_git)
    matched = match_keyword(branches, keyword, case_sensitive)
    return (path, matched, branches)

def main():
    ap = argparse.ArgumentParser(
        description="Find Git repos (recursively) whose branch list contains a keyword."
    )
    ap.add_argument("root", nargs="?", default=".", help="Root directory to scan (default: current dir)")
    ap.add_argument("--keyword", "-k", default="telemetry", help="Keyword to search in branch names (default: telemetry)")
    ap.add_argument("--case-sensitive", action="store_true", help="Case-sensitive match (default: case-insensitive)")
    ap.add_argument("--max-workers", type=int, default=8, help="Max parallel workers (default: 8)")
    ap.add_argument("--git-timeout", type=float, default=5.0, help="Per git command timeout seconds (default: 5.0)")
    ap.add_argument("--follow-symlinks", action="store_true", help="Follow symlinks during directory walk")
    ap.add_argument("--json", action="store_true", help="Emit JSON with repo and matching branches")
    args = ap.parse_args()

    root = Path(args.root).resolve()
    if not root.exists():
        print(f"Root path does not exist: {root}", file=sys.stderr)
        sys.exit(2)

    candidates = list(walk_dirs(root, follow_symlinks=args.follow_symlinks))

    results = []
    with cf.ThreadPoolExecutor(max_workers=args.max_workers) as ex:
        futs = [
            ex.submit(scan_repo, p, args.keyword, args.case_sensitive, args.git_timeout)
            for p in candidates
        ]
        for f in cf.as_completed(futs):
            path, matched, branches = f.result()
            if matched:
                results.append((path, branches))

    # De-duplicate nested worktrees/submodules printing child first is OK.
    # Here we just print all matches; downstream can uniq/sort.
    if args.json:
        payload = [
            {"repo": str(path), "matching": [b for b in branches if (args.keyword in b if args.case_sensitive else args.keyword.lower() in b.lower())], "all_branches_count": len(branches)}
            for path, branches in results
        ]
        print(json.dumps(payload, indent=2))
    else:
        # Plain output: one repo path per line
        for path, _ in results:
            print(str(path))

if __name__ == "__main__":
    main()
