final: prev:
let
  toPlugin = n: v: prev.vimUtils.buildVimPluginFrom2Nix {
    pname = n;
    version = "unstable";
    src = v;
  };
in
{
  vimPlugins = prev.vimPlugins.extend (final': prev': {
    lsp-zero = toPlugin "lsp-zero"
      (prev.fetchFromGitHub {
        owner = "VonHeikemen";
        repo = "lsp-zero.nvim";
        rev = "c1a2726704f6fe87bde61a4439ea5d1d8b127cdd";
        sha256 = "sha256-bi6QODloY8GXZeBHnlNiYUz148e7QBlbTzTDvPe2Nww";
      });
    mason = toPlugin "mason" (prev.fetchFromGitHub {
      owner = "williamboman";
      repo = "mason.nvim";
      rev = "b8c3fceed16d29a166cf73ce55358f13c9f6cfcc";
      sha256 = "sha256-dT1I9qm2ySkElwoVv2xPe4zHNLGetDUMGeB1D2Hq2gc";
    });
    mason-lspconfig = toPlugin "mason-lspconfig" (prev.fetchFromGitHub {
      owner = "williamboman";
      repo = "mason-lspconfig.nvim";
      rev = "aa25b4153d2f2636c3b3a8c8360349d2b29e7ae3";
      sha256 = "sha256-By3Rom8dinWF6+SRcPePz2wX2dBtbiSqsI/mTFya1t8";
    });
    auto-dark-mode = toPlugin "auto-dark-mode"
      (prev.fetchFromGitHub {
        owner = "f-person";
        repo = "auto-dark-mode.nvim";
        rev = "9a7515c180c73ccbab9fce7124e49914f88cd763";
        sha256 = "sha256-kPq/hoSn9/xaienyVWvlhJ2unDjrjhZKdhH5XkB2U0Q";
      });
  });
}
