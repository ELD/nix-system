_final: prev: let
  toPlugin = n: v:
    prev.vimUtils.buildVimPluginFrom2Nix {
      pname = n;
      version = "unstable";
      src = v;
    };
in {
  vimPlugins = prev.vimPlugins.extend (_final': _prev': {
    lsp-zero =
      toPlugin "lsp-zero"
      (prev.fetchFromGitHub {
        owner = "VonHeikemen";
        repo = "lsp-zero.nvim";
        rev = "eb278c30b6c50e99fdfde52f7da0e0ff8d17c07e";
        sha256 = "sha256-C2LvhoNdNXRyG+COqVZv/BcUh6y82tajXipsqdySJJQ=";
      });
    mason = toPlugin "mason" (prev.fetchFromGitHub {
      owner = "williamboman";
      repo = "mason.nvim";
      rev = "6845ccfe009d6fbc5a6a266c285779ad462b234b";
      sha256 = "sha256-bvwLzcVCEY5iVa5cJ4pe5fz0xI2nTkednwHufx6jofk=";
    });
    mason-lspconfig = toPlugin "mason-lspconfig" (prev.fetchFromGitHub {
      owner = "williamboman";
      repo = "mason-lspconfig.nvim";
      rev = "b81c50c4baae7d80b1723b3fa86e814d7754d15b";
      sha256 = "sha256-QAXlPuahdjA2wd3ZZfanWxrHxGtd0W9MYZ0YKNZwJhg=";
    });
    auto-dark-mode =
      toPlugin "auto-dark-mode"
      (prev.fetchFromGitHub {
        owner = "f-person";
        repo = "auto-dark-mode.nvim";
        rev = "9a7515c180c73ccbab9fce7124e49914f88cd763";
        sha256 = "sha256-kPq/hoSn9/xaienyVWvlhJ2unDjrjhZKdhH5XkB2U0Q";
      });
    bgwinch =
      toPlugin "bgwinch"
      (prev.fetchFromGitHub {
        owner = "will";
        repo = "bgwinch.nvim";
        rev = "cafe0e1f2fb55bdd4ae515a3eca34d72e2dd5e99";
        sha256 = "sha256-XDMMgtLM8bQqBJzkwRcD2t0IPMJ9Be2gfte7vUJiYsY=";
      });
  });
}
