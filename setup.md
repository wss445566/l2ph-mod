# 設定 #
  * tortoisesvn 下載及安裝 https://www.youtube.com/watch?v=67stiYwCTI0
  * checkout l2ph-mod source code https://www.youtube.com/watch?v=wTqs2ya35Vw
  * ![http://snag.gy/2ngsx.jpg](http://snag.gy/2ngsx.jpg)
  * 安裝 delphi 2007 https://www.youtube.com/watch?v=jYYovwiBKps
  * 下載 JCL http://sourceforge.net/projects/jcl/
  * 下載 JVCL http://sourceforge.net/projects/jvcl/
  * 下載 FastScript, jwapi2.2a, SyntEdit, TRichView.v11.0 + ScaleRichView.v2.0, TsiLang, TPerlRegEx http://l2phx.pp.ru/arhive/components
  * 安裝 以上 components https://www.youtube.com/watch?v=W_bRwYwb1zU

# 安裝 components 詳細 #
  * 運行 jcl\install.bat
  * 運行 jvcl\install.bat
  * 安裝 TsiLang.exe
  * compile FastScript\Source\fs11.dpk
  * install FastScript\Source\dclfs11.dpk
  * 加入 library search path ![http://snag.gy/qyEwg.jpg](http://snag.gy/qyEwg.jpg)
  * install LSP\component\LSPControlComponent.dpk
  * install SyntEdit\EControl\_Common\Packages\ecComnD11.dpk
  * install SyntEdit\EControl\_SyntEdit\Packages\SyntEditDcl11. Dpk
  * install SyntEdit\EControl\_SyntEdit\Packages\SyntEditDB11. dpk
  * install TRichView.v11.0 + ScaleRichView.v2.0.D2009\1-TRichView\Units\D2007\RVDBPkgD2007.dpk
  * install TRichView.v11.0 + ScaleRichView.v2.0.D2009\1-TRichView\Units\D2007\RVPkgD2007.dpk
  * install TRichView.v11.0 + ScaleRichView.v2.0.D2009\2-RichViewActions\RichViewActionsD2007.dpk
  * install TRichView.v11.0 + ScaleRichView.v2.0.D2009\3-ScaleRichView\Units\D2007\SRVPkgD2007.dpk
  * install TRichView.v11.0 + ScaleRichView.v2.0.D2009\3-ScaleRichView\Units\D2007\DBSRVPkgD2007.dpk
  * install TRichView.v11.0 + ScaleRichView.v2.0.D2009\4-SRVControls\SRVControlsD2007.dpk
  * 複制 TPerlRegEx\pcrelib.dll 到  windows\system32
  * install TPerlRegEx\PerlRegExD2007.dpk


# 下載連結 #
  * http://tortoisesvn.net/downloads.html
  * http://sourceforge.net/projects/jcl/
  * http://sourceforge.net/projects/jvcl/
  * http://l2phx.pp.ru/arhive/components

# 已知問題 #
因為源碼有俄文註解 所以若使用中文語系編譯會出問題
解決方法 可以使用英文語系視窗. 或把系統的 非 UNICODE 程式 改為 俄文
影片最後部份有改系統語系示範