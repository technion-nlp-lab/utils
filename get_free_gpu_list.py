from subprocess import Popen, PIPE
import torch

def get_free_gpu_list():
  CUDA_VISIBLE_DEVICES = os.environ.get('CUDA_VISIBLE_DEVICES')
  if CUDA_VISIBLE_DEVICES:
    del os.environ['CUDA_VISIBLE_DEVICES']
  free_gpu_list = list()
  if torch.cuda.is_available():
    gpu_output = Popen(["nvidia-smi", "-q", "-d", "PIDS"], stdout=PIPE, encoding="utf-8")
    gpu_processes = Popen(["grep", "Processes"], stdin=gpu_output.stdout, stdout=PIPE, encoding="utf-8")
    gpu_output.stdout.close()
    processes_output = gpu_processes.communicate()[0]
    for i, line in enumerate(processes_output.strip().split("\n")):
      if line.endswith("None"):
          print(f"Found Free GPU ID: {i}")
          cuda_device = f"cuda:{i}"
          free_gpu_list.append(torch.device(cuda_device))
    if free_gpu_list:
      os.environ['CUDA_VISIBLE_DEVICES'] = ",".join([str(gpu.index) for gpu in free_gpu_list])
    else:
      print("WARN - No Free GPUs found!")
  return free_gpu_list, CUDA_VISIBLE_DEVICES
