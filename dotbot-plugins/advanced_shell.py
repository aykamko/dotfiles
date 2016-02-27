import os
import subprocess
import sys
import dotbot
from dotbot.messenger.color import Color


class AdvancedShell(dotbot.Plugin):
    '''
    Run shell commands with OS-specific support and user prompts.
    '''

    _directive = 'shell++'

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('Shell++ cannot handle directive %s' % directive)
        return self._process_commands(data)

    def _log_cmd(self, cmd, msg):
        if msg is None:
            self._log.lowinfo(cmd)
        else:
            self._log.lowinfo('%s [%s]' % (msg, cmd))

    def _process_dict_item(self, item, devnull):
        msg = item.get('description')

        stdin = stdout = stderr = devnull
        if item.get('stdall', False) is True:
            stdin = stdout = stderr = None
        else:
            if item.get('stdin', False) is True:
                stdin = None
            if item.get('stdout', False) is True:
                stdout = None
            if item.get('stderr', False) is True:
                stderr = None

        if item.get('condition'):
            ret = subprocess.call(item['condition'], shell=True, stdin=stdin, stdout=stdout,
                                  stderr=stderr, cwd=self._base_directory)
            self._log_cmd(item['condition'], msg)
            if item.get('branch'):
                if ret not in item['branch']:
                    self._log.lowinfo('No rule for condition result: %d' % ret)
                    return True, None
                success = self._process_commands(item['branch'][ret], False)
                return success, not success
            else:
                return ret == item.get('continue-if', 0), None

        elif item.get('prompt'):
            default = False if type(item.get('default')) != bool else item['default']
            if default:
                choices = ' [Y/n] '
            else:
                choices = ' [y/N] '
            sys.stdout.write(Color.YELLOW + item['prompt'] + choices)
            if os.getenv('DOTBOT_DEFAULT', False):
                sys.stdout.write(('y' if default else 'n') + Color.RESET + os.linesep)
                return True, None
            else:
                choice = raw_input().lower()
                sys.stdout.write(Color.RESET + os.linesep)

            if default:
                return choice not in ['no', 'n'], None
            else:
                return choice not in ['yes', 'ye', 'y'], None

        elif item.get('platforms'):
            uname = os.uname()[0].lower()
            platforms = item['platforms']
            if uname not in platforms:
                return False, 'No rule for platform'
            cmd = platforms[uname]
            if isinstance(cmd, dict) or isinstance(cmd, list):
                success = self._process_commands(cmd, False)
                return success, not success

        elif item.get('command'):
            cmd = item['command']

        else:
            return False, 'Bad item: {}'.format(item)

        self._log_cmd(cmd, msg)
        ret = subprocess.call(cmd, shell=True, stdin=stdin, stdout=stdout,
                              stderr=stderr, cwd=self._base_directory)
        if ret != 0:
            return False, 'Command [%s] failed' % cmd
        return True, None

    def _process_commands(self, data, log_suffix=True):
        success = True
        with open(os.devnull, 'w') as devnull:
            for item in data:
                stdin = stdout = stderr = devnull
                if isinstance(item, dict):
                    keep_going, err = self._process_dict_item(item, devnull)
                    if not keep_going:
                        if err:
                            if err is not True:
                                self._log.warning(err)
                            success = False
                        break
                    else:
                        continue
                elif isinstance(item, list):
                    cmd = item[0]
                    msg = item[1] if len(item) > 1 else None
                else:
                    cmd = item
                    msg = None
                self._log_cmd(cmd, msg)
                ret = subprocess.call(cmd, shell=True, stdin=stdin, stdout=stdout,
                                      stderr=stderr, cwd=self._base_directory)
                if ret != 0:
                    success = False
                    self._log.warning('Command [%s] failed' % cmd)
        if log_suffix:
            if success:
                self._log.info('All commands have been executed')
            else:
                self._log.error('Some commands were not successfully executed')
        return success
