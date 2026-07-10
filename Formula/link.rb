class Link < Formula
  desc "Local Markdown memory for AI agents"
  homepage "https://github.com/gowtham0992/link"
  url "https://github.com/gowtham0992/link/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "79a732c0707ae8d243f6c2c05835fde7175385810b783cb13103d7a046682d1e"
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

    (bin/"lnk").write <<~SH
      #!/bin/sh
      exec "#{python3}" "#{libexec}/link.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      Try Link:
        lnk demo
        lnk serve link-demo

      Then open:
        http://127.0.0.1:3000
        http://127.0.0.1:3000/graph

      To create a personal wiki:
        lnk init ~/link

      For MCP clients, install link-mcp with the agent installer or a venv:
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
