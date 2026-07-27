{ pkgs, lib, ... }:

{
  home = {
    stateVersion = "26.05";
    packages = with pkgs; [
      zsh-autosuggestions
      zsh-syntax-highlighting
    ];
  };

  programs = {
    # ── ZSH ──
    zsh = {
      enable = true;
      shellAliases = {
        # igual que en Fedora
        ".." = "cd ..";
        c = "clear";
        nf = "fastfetch";
        pf = "fastfetch";
        ff = "fastfetch";
        ls = "eza -a --icons=always";
        ll = "eza -al --icons=always";
        lt = "eza -a --tree --level=1 --icons=always";
        v = "$EDITOR";
        vim = "$EDITOR";
        gs = "git status";
        ga = "git add";
        gc = "git commit -m";
        gp = "git push";
        gpl = "git pull";
        gst = "git stash";
        gfo = "git fetch origin";
        gcheck = "git checkout";
      };
      initContent = lib.mkOrder 550 ''
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # ── Modo emacs primero ──
        bindkey -e

        # ── Historial (como en Fedora) ──
        HISTFILE=~/.zsh_history
        HISTSIZE=10000
        SAVEHIST=10000
        setopt appendhistory

        # ── Autosuggestions (Alt+L para aceptar) ──
        bindkey '^[l' autosuggest-accept

        # ── Completado ──
        bindkey '^[[Z' reverse-menu-complete
        WORDCHARS=''${WORDCHARS/\/}
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*' menu yes=long select

        # ── Env ──
        export EDITOR=nvim
        export LANG=en_US.UTF-8
        export LC_CTYPE=en_US.UTF-8
      '';
    };

    # ── FZF ──
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # ── Starship ──
    starship = {
      enable = true;
      settings.add_newline = false;
    };

    # ── Zoxide ──
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    # ── Direnv ──
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    # ── Tmux ──
    tmux = {
      enable = true;
      extraConfig = ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        set -g mouse on

        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix

        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        bind -n S-Left  previous-window
        bind -n S-Right next-window

        bind -n M-H previous-window
        bind -n M-L next-window

        run '~/.tmux/plugins/tpm/tpm'

        set -g @catppuccin_flavour 'mocha'

        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'tmux-plugins/tmux-sensible'
        set -g @plugin 'christoomey/vim-tmux-navigator'
        set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
        set -g @plugin 'tmux-plugins/tmux-yank'

        set-window-option -g mode-keys vi

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind 't' split-window -v -c "#{pane_current_path}"
        bind '%' split-window -h -c "#{pane_current_path}"

        bind -n C-l send-keys C-l
      '';
    };
  };
}
