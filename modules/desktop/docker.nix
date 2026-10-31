{ ... }:

{
  # docker: container engine. The nixpkgs docker package already bundles the
  # Compose v2 plugin, so `docker compose ...` works without extra packages.
  virtualisation.docker.enable = true;

  # Run docker without sudo. Note: the docker group is root-equivalent.
  users.users.shirok.extraGroups = [ "docker" ];
}
