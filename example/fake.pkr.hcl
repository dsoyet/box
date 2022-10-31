source "null" "test"{
}

build {
  source "null.test" {
    ssh_host = "test"
    ssh_username = "test"
    communicator = "none"
  }

  provisioner "shell-local" {
    inline = [
      "echo ${var.image_id}"
    ]
  }
}