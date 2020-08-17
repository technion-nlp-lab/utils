from collections import defaultdict
from subprocess import Popen, PIPE
from GoogleDriveHandler import GoogleDriveHandler
from os import environ
from csv import DictWriter
import re


def get_gpu_usage():
    CUDA_VISIBLE_DEVICES = environ.get('CUDA_VISIBLE_DEVICES')
    if CUDA_VISIBLE_DEVICES:
        del environ['CUDA_VISIBLE_DEVICES']
    gpu_pid_dict = defaultdict(list)
    gpu_output = Popen(["nvidia-smi", "-q", "-d", "PIDS"], stdout=PIPE, encoding="utf-8")
    gpu_output = gpu_output.communicate()[0].strip().split("\n")
    gpu_num = -1
    for line in gpu_output:
        line = line.strip()
        if line.startswith("GPU "):
            gpu_num += 1
        if line.startswith("Processes"):
            if "None" in line:
                gpu_pid_dict[gpu_num] = []
        if line.startswith("Process ID"):
            pid = re.search("\d+", line).group(0)
            gpu_pid_dict[gpu_num].append(pid)
    user_gpu_dict = defaultdict(set)
    for gpu, pid_list in gpu_pid_dict.items():
        for pid in pid_list:
            pid_output = Popen(["ps", "-u", "-p", pid], stdout=PIPE, encoding="utf-8")
            pid_output = pid_output.communicate()[0].strip().split("\n")
            if len(pid_output) > 1:
                user = pid_output[1].split(" ")[0]
                user_gpu_dict[user].add(gpu)
    return gpu_pid_dict, user_gpu_dict


def write_and_upload_csv(user_gpu_dict):
    drive_handler = GoogleDriveHandler()
    upload_dir = f"{drive_handler.local_root}/Technion/NLP Lab GPU Resources/Usage"
    csv_file = f"{upload_dir}/{environ.get('HOSTNAME')}.csv"
    with open(csv_file, 'w', newline='') as f:
        fieldnames = ['user', 'num_gpus']
        writer = DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for key, val in user_gpu_dict.items():
            writer.writerow({"user": key, "num_gpus": len(val)})
    print(drive_handler.push_files(csv_file, ["-force"]))


def main():
    _, user_gpu_dict = get_gpu_usage()
    write_and_upload_csv(user_gpu_dict)


if __name__ == "__main__":
    main()
