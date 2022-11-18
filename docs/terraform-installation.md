# Terraform setup

HashiCorp Terraform is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share. You can then use a consistent workflow to provision and manage all of your infrastructure throughout its lifecycle. Terraform can manage low-level components like compute, storage, and networking resources, as well as high-level components like DNS entries and SaaS features.

## 1. Install Teraform in your workstation

!!!Note
  	Participants can use virtual machine with Windows or work on personal laptop. Please follow installation instructions for the OS on your laptops.

To use Terraform you will need to install it. HashiCorp distributes Terraform as a binary package. You can also install Terraform using popular package managers.

###  1.1 For CentOS/RHEL distribution:

Install `yum-config-manager` to manage your repositories.

    sudo yum install -y yum-utils

Use `yum-config-manager` to add the official HashiCorp Linux repository.

    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

Install Terraform from the new repository.

    sudo yum -y install terraform

### 1.2. For Windows OS:

To install Terraform, find the appropriate package for your system and download it as a zip archive:

    https://releases.hashicorp.com/terraform/1.3.3/terraform_1.3.3_windows_amd64.zip

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/terraform-download.png" width = 800>

After downloading Terraform, unzip the package. Terraform runs as a single binary named terraform. Any other files in the package can be safely removed and Terraform will still function.

Copy the terraform.bin to C:\Windows folder.

Finally, make sure that the terraform binary is available on your PATH. The path can be edited through:
1) Find `Advanced system settings` -> `Advanced` -> `Environment Variables`
2) Find PATH variable and click edit to change
3) Verify if C:\Windows exists in the path and if not add it to the list

### 1.3 For Macbook with OS X:

Homebrew is a free and open-source package management system for Mac OS X. Install the official Terraform formula from the terminal.
First, install the HashiCorp tap, a repository of all our Homebrew packages.

    brew tap hashicorp/tap

Now, install Terraform with hashicorp/tap/terraform.

    brew install hashicorp/tap/terraform

!!!Note
	This installs a signed binary and is automatically updated with every new official release.


To update to the latest version of Terraform, first update Homebrew.

    brew update

Then, run the upgrade command to download and use the latest Terraform version.
```
  brew upgrade hashicorp/tap/terraform
  ==> Upgrading 1 outdated package:
  hashicorp/tap/terraform 0.15.3 -> 1.0.0
  ==> Upgrading hashicorp/tap/terraform 0.15.3 -> 1.0.0
```

### 1.3 Verify the installation

Verify that the installation worked by opening a new terminal session and listing Terraform's available subcommands.

```
terraform -help
Usage: terraform [-version] [-help] <command> [args]

The available commands for execution are listed below.
The most common, useful commands are shown first, followed by
less common or more advanced commands. If you're just getting
started with Terraform, stick with the common commands. For the
other commands, please read the help and docs before usage.
#...
```

Add any subcommand to terraform -help to learn more about what it does and available options.

```
 terraform -help plan
```
