source "yandex" "debian_docker" {
  disk_type           = "network-hdd"
  folder_id           = "b1g3nl8irq59s4vhm8mk"
  image_description   = "Debian 11 with Docker, htop and tmux"
  image_name          = "debian-11-docker-{{timestamp}}"
  image_family        = "debian-docker"
  source_image_family = "debian-11"
  ssh_username        = "debian"
  subnet_id           = "e9bsttrtcuv1qegmtqid"
  token               = "xxx"
  use_ipv4_nat        = true
  zone                = "ru-central1-a"

  # Экономичные параметры
  platform_id         = "standard-v2"          # Платформа v2
  instance_cores      = 2                      # 2 vCPU
  instance_core_fraction = 5                   # 5% мощности
  instance_mem_gb     = 1                      # 1 GB RAM
  preemptible         = true                   # Прерываемая ВМ
  
}

build {
  sources = ["source.yandex.debian_docker"]

  provisioner "shell" {
    inline = [
      # Обновление пакетов
      "sudo apt-get update -y",
      
      # Установка зависимостей
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
      
      # Установка htop и tmux
      "sudo apt-get install -y htop tmux",
      
      # Добавление Docker GPG key
      "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      
      # Добавление Docker репозитория
      "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      
      # Установка Docker
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      
      # Добавление пользователя debian в группу docker
      "sudo usermod -aG docker debian",
      
      # Включение Docker автозапуска
      "sudo systemctl enable docker",
      
      # Проверка версий
      "echo 'Docker version:' && docker --version",
      "echo 'htop version:' && htop --version",
      "echo 'tmux version:' && tmux -V"
    ]
  }
}
