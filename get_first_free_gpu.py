from subprocess import Popen, PIPE
import torch

def get_first_free_gpu():
    if torch.cuda.is_available():
        gpu_output = Popen(["nvidia-smi", "-q", "-d", "PIDS"], stdout=PIPE, text=True)
        gpu_processes = Popen(["grep", "Processes"], stdin=gpu_output.stdout, stdout=PIPE, text=True)
        gpu_output.stdout.close()
        processes_output = gpu_processes.communicate()[0]
        for i, line in enumerate(processes_output.strip().split("\n")):
            if line.endswith("None"):
                print(f"Found Free GPU ID: {i}")
                cuda_device = f"cuda:{i}"
                torch.cuda.set_device(cuda_device)
                return torch.device(cuda_device)
        print("WARN - No Free GPU found! Running on CPU instead...")
    return torch.device("cpu")
