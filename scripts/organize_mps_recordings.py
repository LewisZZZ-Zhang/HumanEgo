#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Move or copy local MPS recording folders into the HumanEgo data layout.

Examples
--------
    python scripts/organize_mps_recordings.py \
        --source /Users/lewis/Downloads/AriaRecordings \
        --task serve_bread

    python scripts/organize_mps_recordings.py \
        --source /Users/lewis/Downloads/AriaRecordings \
        --task serve_bread \
        --dry-run

The destination layout is:
    data/<task>/aria/mps_<task>_<idx>_vrs/
"""
import argparse
import os
import re
import shutil
from pathlib import Path


MPS_NAME_RE = re.compile(r"^mps_.+_vrs$")


def natural_sort_key(path: Path):
    parts = re.split(r"(\d+)", path.name)
    return [int(part) if part.isdigit() else part.lower() for part in parts]


def is_mps_dir(path: Path) -> bool:
    return path.is_dir() and MPS_NAME_RE.match(path.name) is not None


def find_mps_dirs(source: Path, recursive: bool) -> list[Path]:
    if is_mps_dir(source):
        return [source]

    if not source.is_dir():
        raise FileNotFoundError(f"Source folder does not exist: {source}")

    if not recursive:
        return sorted((p for p in source.iterdir() if is_mps_dir(p)), key=natural_sort_key)

    found = []
    for root, dirs, _ in os.walk(source):
        root = Path(root)
        dirs.sort()
        for dirname in list(dirs):
            candidate = root / dirname
            if is_mps_dir(candidate):
                found.append(candidate)
                dirs.remove(dirname)
    return sorted(found, key=natural_sort_key)


def validate_task(task: str) -> str:
    if not task:
        raise ValueError("Task name is empty.")
    if "/" in task or "\\" in task:
        raise ValueError(f"Task name cannot contain path separators: {task}")
    return task


def build_plan(mps_dirs: list[Path], args) -> list[tuple[Path, Path, list[str]]]:
    data_root = Path(args.data_root).expanduser().resolve()
    task = validate_task(args.task)
    plan = []

    for idx, src in enumerate(mps_dirs):
        warnings = []
        dest = data_root / task / "aria" / f"mps_{task}_{idx:03d}_vrs"

        if dest.exists():
            raise FileExistsError(
                f"Destination already exists: {dest}. Move it away or choose a different --task."
            )

        if not (src / "sample.vrs").exists():
            warnings.append("missing sample.vrs")
        if not (src / "slam").exists():
            warnings.append("missing slam/")
        if not (src / "hand_tracking").exists():
            warnings.append("missing hand_tracking/")

        plan.append((src, dest, warnings))

    return plan


def execute_plan(plan: list[tuple[Path, Path, list[str]]], copy: bool, dry_run: bool) -> None:
    action = "COPY" if copy else "MOVE"
    for src, dest, warnings in plan:
        rel_warning = f"  [warn: {', '.join(warnings)}]" if warnings else ""
        print(f"{action}: {src} -> {dest}{rel_warning}")
        if dry_run:
            continue

        dest.parent.mkdir(parents=True, exist_ok=True)
        if copy:
            shutil.copytree(src, dest)
        else:
            shutil.move(str(src), str(dest))


def main():
    parser = argparse.ArgumentParser(
        description="Organize mps_*_vrs folders into data/<task>/aria/.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("--source", required=True, help="Folder containing mps_*_vrs folders.")
    parser.add_argument("--task", required=True, help="Task name for destination folders, e.g. serve_bread.")
    parser.add_argument("--data-root", default="./data", help="HumanEgo data root.")
    parser.add_argument("--recursive", action="store_true", help="Search source recursively.")
    parser.add_argument("--copy", action="store_true", help="Copy folders instead of moving them.")
    parser.add_argument("--dry-run", action="store_true", help="Print planned actions without changing files.")
    args = parser.parse_args()

    source = Path(args.source).expanduser().resolve()
    mps_dirs = find_mps_dirs(source, args.recursive)
    if not mps_dirs:
        raise SystemExit(f"No mps_*_vrs folders found in: {source}")

    plan = build_plan(mps_dirs, args)
    execute_plan(plan, copy=args.copy, dry_run=args.dry_run)

    verb = "Planned" if args.dry_run else ("Copied" if args.copy else "Moved")
    print(f"{verb} {len(plan)} MPS folder(s).")


if __name__ == "__main__":
    main()
