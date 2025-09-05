import importlib
import pkgutil
import conf_d
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

# Suppress linter errors
config: ConfigAPI = config  # noqa: F821 # pyright: ignore[reportUndefinedVariable]
c: ConfigContainer = c  # noqa: F821 # pyright: ignore[reportUndefinedVariable]

config.load_autoconfig()
for module_info in pkgutil.iter_modules(conf_d.__path__):
    module = importlib.import_module(f"conf_d.{module_info.name}")
    if hasattr(module, "apply"):
        module.apply(config, c)
