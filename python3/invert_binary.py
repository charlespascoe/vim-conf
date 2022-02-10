import re

invert_binary_subs = [
    ('true', 'false'),
    ('True', 'False'),
    ('TRUE', 'FALSE'),
    ('y', 'n'),
    ('yes', 'no'),
    ('Yes', 'No'),
    ('YES', 'NO'),
    ('Required', 'Optional'),
    (re.compile(r'enabl(ing|e[sd]?)'), r'disabl\1'),
    (re.compile(r'disabl(ing|e[sd]?)'), r'enabl\1'),
    (re.compile(r'Enabl(ing|e[sd]?)'), r'Disabl\1'),
    (re.compile(r'Disabl(ing|e[sd]?)'), r'Enabl\1'),
]

def invert_binary(s):
    for a, b in invert_binary_subs:
        if isinstance(a, re.Pattern):
            if a.match(s):
                return a.sub(b, s)
        elif s == a:
            return b
        elif s == b:
            return a

    return ''
