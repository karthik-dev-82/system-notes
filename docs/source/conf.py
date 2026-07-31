import shutil

project = "Bash Miscellaneous"
copyright = "2026, Karthik"
author = "Karthik"

extensions = [
    "sphinxcontrib.plantuml",
]

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

html_theme = "sphinx_rtd_theme"

# CI (see .github/workflows/docs.yml) installs the Debian/Ubuntu "plantuml"
# package, which provides a `plantuml` launcher script on PATH. Fall back to
# invoking the jar directly for local builds that only installed the jar.
_plantuml_bin = shutil.which("plantuml")
if _plantuml_bin:
    plantuml = _plantuml_bin
else:
    plantuml = "java -jar /usr/share/plantuml/plantuml.jar"

plantuml_output_format = "svg_img"

# --- PDF (latexpdf) output -------------------------------------------------
# xelatex (not pdflatex) because the docs use Unicode arrows/checkmarks
# (->, <->, Y/N) throughout. DejaVu fonts give broad Unicode coverage, but
# pictographic emoji (setup, phone, camera, etc.) still won't render as
# color glyphs in the PDF -- that needs a dedicated emoji font/package this
# repo doesn't pull in. They'll likely show as blank boxes; harmless, just
# cosmetic.
latex_engine = "xelatex"
latex_elements = {
    "papersize": "a4paper",
    "pointsize": "11pt",
    "fontpkg": r"""
\setmainfont{DejaVu Serif}
\setsansfont{DejaVu Sans}
\setmonofont{DejaVu Sans Mono}
""",
}
latex_documents = [
    ("index", "bash-miscellaneous.tex", "Bash Miscellaneous", "Karthik", "manual"),
]
