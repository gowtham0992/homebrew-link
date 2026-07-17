class Link < Formula
  desc "Local Markdown memory for AI agents"
  homepage "https://github.com/gowtham0992/link"
  url "https://github.com/gowtham0992/link/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "1322c6d4e82b7711924852a5ca853384e4210612374475a77f4c2bae9933b1a2"
  license "MIT"
  head "https://github.com/gowtham0992/link.git", branch: "main"

  depends_on "python@3.14"

  def python3
    formula_opt_bin("python@3.14")/"python3.14"
  end

  def install
    libexec.install "link.py", "serve.py", "LINK.md", ".linkignore"
    libexec.install "logo.svg"
    libexec.install "logo.png" if File.exist?("logo.png")

    (libexec/"mcp_package").mkpath
    (libexec/"mcp_package").install "mcp_package/link_core"

    # Prefer Link's managed venv when it hosts the link-mcp package: the
    # Homebrew python is externally managed (PEP 668), so the optional
    # semantic/rerank tiers can only live in that venv. Same code runs
    # either way — link.py always uses its own bundled link_core first.
    (bin/"lnk").write <<~SH
      #!/bin/sh
      LINK_VENV_PY="$HOME/.link-mcp-venv/bin/python"
      if [ -x "$LINK_VENV_PY" ] && "$LINK_VENV_PY" -c "import link_core" >/dev/null 2>&1; then
        exec "$LINK_VENV_PY" "#{libexec}/link.py" "$@"
      fi
      exec "#{python3}" "#{libexec}/link.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      Try Link:
        lnk try
        lnk proof

      Then open:
        http://127.0.0.1:3000
        http://127.0.0.1:3000/graph

      To create a personal wiki and wire up an agent:
        lnk onboard
        lnk onboard --agent claude-code --hooks --write

      For MCP clients, install link-mcp with the agent installer or a venv
      (lnk automatically uses ~/.link-mcp-venv when it exists):
        python3 -m venv ~/.link-mcp-venv
        ~/.link-mcp-venv/bin/python -m pip install --upgrade pip link-mcp
    EOS
  end

  test do
    system bin/"lnk", "--version"
    system bin/"lnk", "demo", testpath/"link-demo", "--force"
    system bin/"lnk", "validate", testpath/"link-demo"
    system bin/"lnk", "status", "--validate", testpath/"link-demo"
  end
end
