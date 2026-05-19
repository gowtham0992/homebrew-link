class Link < Formula
  desc "Local Markdown memory for AI agents"
  homepage "https://github.com/gowtham0992/link"
  url "https://github.com/gowtham0992/link/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "7a62023f212ba1672b295cc5c6539709d29f34c1701bb41988487256cb771e86"
  license "MIT"
  head "https://github.com/gowtham0992/link.git", branch: "main"

  depends_on "python@3.14"

  def python3
    Formula["python@3.14"].opt_bin/"python3.14"
  end

  def install
    libexec.install "link.py", "serve.py", "LINK.md", ".linkignore"
    libexec.install "logo.svg"
    libexec.install "logo.png" if File.exist?("logo.png")

    (libexec/"mcp_package").mkpath
    (libexec/"mcp_package").install "mcp_package/link_core"

    (bin/"link").write <<~SH
      #!/bin/sh
      exec "#{python3}" "#{libexec}/link.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      Try Link:
        link demo
        link serve link-demo

      Then open:
        http://127.0.0.1:3000
        http://127.0.0.1:3000/graph

      To create a personal wiki:
        link init ~/link

      For MCP clients, install link-mcp with the agent installer or a venv:
        python3 -m venv ~/.link-mcp-venv
        ~/.link-mcp-venv/bin/python -m pip install --upgrade pip link-mcp
    EOS
  end

  test do
    system bin/"link", "--version"
    system bin/"link", "demo", testpath/"link-demo", "--force"
    system bin/"link", "validate", testpath/"link-demo"
    system bin/"link", "status", "--validate", testpath/"link-demo"
  end
end
