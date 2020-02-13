import sys
import argparse
import json
from parser import parse_doc


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('bullets', metavar='BULLETS', help='A string containing all bullet types')

    args = parser.parse_args()

    lines = [line.rstrip() for line in sys.stdin.readlines()]

    doc = parse_doc(lines, normalise_bullets(args.bullets))

    json.dump(doc.to_dict(), sys.stdout)


if __name__ == '__main__':
    main()
