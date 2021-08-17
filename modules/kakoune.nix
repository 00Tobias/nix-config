{ config, pkgs, ... }: {

  programs = {
    kakoune = {
      enable = true;
      config = {
        hooks = [
          lineNumberEnter = {
          name = "ModeChange";
          option = "push:.*:insert";
          commands = "add-highlighter -override global/line-numbers number-lines -hlcursor";
        };

          lineNumberExit = {
          name = "ModeChange";
          option = "pop:insert:.*";
          commands = "add-highlighter -override global/line-numbers number-lines -relative -hlcursor";
        };
        ];
        numberLines = {
          enable = true;
          highlightCursor = true;
          relative = true;
        };
        ui = {
          enableMouse = true;
          assistant = "cat";
          statusLine = "top";
        };
      };
    };
  };
}

