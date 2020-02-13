import argparse
import sys
import json
from load import bulletnotes


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('bullet_types', metavar='TYPES', help='A string of the bullet types')

    args = parser.parse_args()

    types = {bullet_type for bullet_type in args.bullet_types if not bullet_type.isspace()}

    doc_dict = json.load(sys.stdin)

    doc = bulletnotes.Document.from_dict(doc_dict)

    tasks = doc.find_all(lambda bullet : bullet.bullet_type in types)

    json.dump([task.to_dict() for task in tasks], sys.stdout)


if __name__ == '__main__':
    main()
