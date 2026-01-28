### so I don't forget how it all works

ssh-ing onto the server is protected by tailscale, to ssh run

`ssh -i ~/.ssh/id_rsa_mf root@one-server`

there's an auto-update script in scripts that can be executed to manually update all running services and cleanup docker
