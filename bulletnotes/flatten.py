import json
import sys
from load import bulletnotes


def main():
    bullet_array = json.load(sys.stdin)

    if type(bullet_array) != list:
        raise Exception('Expected array input')

    bullets = [bulletnotes.Bullet.from_dict(d) for d in bullet_array]

    flattened = [
        {
            'type': bullet.bullet_type,
            'content': bullet.content,
            'subbullets': '\n'.join(str(sb) for sb in bullet.subbullets)
        }
        for bullet in bullets
    ]

    json.dump(flattened, sys.stdout)


if __name__ == '__main__':
    main()
