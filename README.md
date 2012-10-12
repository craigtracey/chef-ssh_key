Description
===========

Create and remove ssh public keys for existing users/groups of users.

Requirements
============

Platform
--------

* Debian, Ubuntu
* CentOS, Red Hat, Fedora
* FreeBSD

Usage
=====

Add a key to a single existing user:

ssh_key_manage "ctracey" do
  keys ["ssh-rsa <public key> ctracey@ctracey"]
end

Remove a key for an existing user:

ssh_key_manage "ctracey" do
  keys ["ssh-rsa <some public key> ctracey@ctracey"]
  action :remove
end

Add keys for a group of users:

ssh_key_manage_group "default" do

with data from data bag ssh_key/default.json:

{
    "id": "default",
    "users": {
        "ctracey" : ["ssh-rsa <some public key> ctracey@ctracey"]
    }
}





