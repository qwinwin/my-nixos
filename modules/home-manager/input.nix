{ config, pkgs, ... }:

{
  # Rime Configuration
  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      "schema_list":
        - schema: rime_ice
      "menu/page_size": 9
      "ascii_composer/switch_key":
        Shift_L: commit_code
        Shift_R: commit_code
        Control_L: noop
        Control_R: noop
   '';

  xdg.dataFile."fcitx5/rime/rime_ice.custom.yaml".text = ''
    patch:
      "switches/@0/reset": 1
  '';
}
