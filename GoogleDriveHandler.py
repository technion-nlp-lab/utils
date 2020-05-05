from os import getenv
from subprocess import run
from pathlib import Path


HOME_DIR = getenv('HOME')


class GoogleDriveHandler:
    def __init__(self,
                 local_root: str = f"{HOME_DIR}/GoogleDrive",
                 drive_binary: str = f"{HOME_DIR}/bin/go/packages/bin/drive",
                 default_timeout: int = 600):
        self.local_root = local_root
        self.drive_binary = drive_binary
        self.default_args = ["-no-prompt"]
        self.default_timeout = default_timeout

    def _execute_drive_cmd(self, subcommand: str, path: str, cmd_args: list):
        if subcommand not in ("pull", "push"):
            raise ValueError("Only pull and push commands are currently supported")
        cmd = [self.drive_binary, subcommand] + self.default_args + cmd_args + [path]
        cmd_return = run(cmd, capture_output=True, text=True, timeout=self.default_timeout, cwd=HOME_DIR)
        return cmd_return.returncode, cmd_return.stdout, cmd_return.stderr

    def push_files(self, path: str, cmd_args: list = []):
        try:
            push_return = self._execute_drive_cmd("push", path, ["-files"] + cmd_args)
            if push_return[0] == 0:
                message = f"Successfully pushed results to Google Drive: {path}"
            else:
                message = f"Failed to push results to Google Drive: {path}\nExit Code: {push_return[0]}\nSTDOUT: {push_return[1]}\nSTDERR: {push_return[2]}"
        except Exception as e:
            message = f"ERROR: {e}\nFailed to push results to Google Drive: {path}"
        return message

    def pull_files(self, path: str, cmd_args: list = []):
        return self._execute_drive_cmd("pull", path, ["-files"] + cmd_args)



def test_GoogleDriveHandler_push_files():
    handler = GoogleDriveHandler()
    test_file_path = f"{handler.local_root}/test_file"
    Path(test_file_path).touch
    push_return = handler.push_files(test_file_path)
    print(push_return)
    assert push_return[0] == 0


if __name__ == "__main__":
    test_GoogleDriveHandler_push_files()
