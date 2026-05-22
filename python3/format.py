from __future__ import annotations

import difflib
import subprocess
from typing import Optional

import vim


def format(
    cmd: str, args: list[str], start: int = 0, end: Optional[int] = None
) -> None:
    """Run a formatter on a range of lines in the current Vim buffer, preserving
    marks, jump history, and the window view position.

    Feeds lines `start` to `end` (inclusive) as stdin to `cmd`, then uses
    difflib to apply only the minimal set of insertions, deletions, and
    replacements back to the buffer.  Lines that are unchanged by the formatter
    are left completely untouched, preserving marks and jump history on those
    lines.  Saves and restores the window view (scroll position etc.) around the
    edit.

    Raises ``RuntimeError`` if the formatter exits with a non-zero status; in
    that case the buffer is not modified.

    Args:
        cmd:   Executable name or path (e.g. ``"gofmt"``, ``"/usr/bin/black"``).
        args:  Command-line arguments passed to the executable.
        start: First line index, 0-based (default: 0).
        end:   Last line index, 0-based inclusive (default: ``len(buffer) - 1``).
    """
    buf = vim.current.buffer

    if end is None:
        end = len(buf) - 1

    original: list[str] = list(buf[start : end + 1])

    view = vim.eval("winsaveview()")

    proc = subprocess.run(
        [cmd, *args],
        input="\n".join(original) + "\n",
        capture_output=True,
        text=True,
    )

    if proc.returncode != 0:
        raise RuntimeError(
            f"formatter '{cmd}' exited with code {proc.returncode}: {proc.stderr.strip()}"
        )

    formatted: list[str] = proc.stdout.splitlines()

    # autojunk=False prevents difflib from heuristically ignoring "popular"
    # lines, which would produce a larger diff and move marks unnecessarily.
    matcher = difflib.SequenceMatcher(None, original, formatted, autojunk=False)

    # Apply edits in reverse order so that mutations at later positions do not
    # invalidate the indices of pending edits earlier in the buffer.
    for tag, i1, i2, j1, j2 in reversed(matcher.get_opcodes()):
        if tag == "equal":
            continue

        # All three non-equal opcodes reduce to a single slice assignment:
        #   replace: overwrites buf[start+i1 : start+i2] with formatted[j1:j2]
        #   delete:  j1 == j2, so assigns [], removing the lines
        #   insert:  i1 == i2, so inserts into a zero-width slice
        buf[start + i1 : start + i2] = formatted[j1:j2]

    cur_lnum, cur_col = vim.current.window.cursor
    line_offset = cur_lnum - int(view["lnum"])
    view["lnum"] = cur_lnum
    view["col"] = cur_col
    view["topline"] = int(view["topline"]) + line_offset
    vim.vars["_vimformat_view"] = view
    vim.command("call winrestview(g:_vimformat_view)")
    del vim.vars["_vimformat_view"]
