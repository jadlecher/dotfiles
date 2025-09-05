from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer
import catppuccin
import subprocess

# Suppress linter errors
config: ConfigAPI = config  # noqa: F821 # pyright: ignore[reportUndefinedVariable]
c: ConfigContainer = c  # noqa: F821 # pyright: ignore[reportUndefinedVariable]


def get_system_theme() -> str:
    """Return 'dark' or 'light' depending on system theme, or 'light' as fallback."""
    try:
        # GNOME 42+ supports color-scheme
        # Value could be "'default'" or "'prefer-dark'"
        result = subprocess.run(
            ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"],
            capture_output=True,
            check=True,
            text=True,
        )
        if "prefer-dark" in result.stdout:
            return "dark"
        return "light"
    except Exception:
        # Fallback for GTK 3-based desktops: check if theme name ends with '-dark'
        try:
            result = subprocess.run(
                ["gsettings", "get", "org.gnome.desktop.interface", "gtk-theme"],
                capture_output=True,
                check=True,
                text=True,
            )
            theme = result.stdout.strip().strip("'\"")
            if theme.lower().endswith("-dark"):
                return "dark"
        except Exception:
            pass
        # Default fallback
        return "light"


theme_style = get_system_theme()
catppuccin_palette = "mocha" if theme_style == "dark" else "latte"

config.load_autoconfig()
catppuccin.setup(c, catppuccin_palette, True)
config.set("colors.webpage.darkmode.enabled", theme_style == "dark")
config.set("colors.webpage.bg", "black" if theme_style == "dark" else "white")
