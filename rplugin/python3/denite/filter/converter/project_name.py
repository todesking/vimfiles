from ..base import Base
import re

class Filter(Base):
    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'converter/project_name'
        self.description = 'add project name prefix'

    def filter(self, context):
        def f(path):
            info = self.vim.call('current_project#file_info', path)
            if(info['name'] == ''):
                return path
            else:
                return '[' + info['name'] + '] ' + info['file_path']
        for candidate in context['candidates']:
            candidate['abbr'] = f(candidate['word'])
        return context['candidates']

