from ..base import Base

def decompose(a, b):
    l = min(len(a), len(b))
    for i in range(l):
        if a[i] != b[i]:
            return (a[0:i], a[i:], b[i:])
    return (a[0:l], a[l:], b[l:])

class Filter(Base):
    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'converter/mark_dup'
        self.description = 'mark duplicated part'

    def filter(self, context):
        prev = []
        for candidate in context['candidates']:
            cur = candidate['abbr'].split('/')
            prefix, a, _ = decompose(cur, prev)
            if prefix != []:
                candidate['abbr'] = '{{{' + '/'.join(prefix) + '}}}/' + '/'.join(a)
            prev = cur
        return context['candidates']
