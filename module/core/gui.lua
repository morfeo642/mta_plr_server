
--[[!
	\file
	\brief Este módulo reemplaza las funciones estandard de la interfaz de 
	usuario de MTA, por las exportadas por el recurso dxgui. Este módulo no funcionará
	correctamente si previamente (antes de importar el módulo), el recurso dxgui 
	no está en ejecución.
]]

-- Shared. 

function guiCreateRootPane(...) return exports.dxgui:dxCreateRootPane(...) end
function guiGetRootPane(...) return exports.dxgui:dxGetRootPane(...) end
function guiRefreshThemes(...) return exports.dxgui:dxRefreshThemes(...) end
function guiGetTheme(...) return exports.dxgui:dxGetTheme(...) end
function guiGetDefaultTheme(...) return exports.dxgui:dxGetDefaultTheme(...) end
function guiGetPosition(...) return exports.dxgui:dxGetPosition(...) end
function guiGetSize(...) return exports.dxgui:dxGetSize(...) end
function guiGetVisible(...) return exports.dxgui:dxGetVisible(...) end
function guiGetElementTheme(...) return exports.dxgui:dxGetElementTheme(...) end
function guiGetFont(...) return exports.dxgui:dxGetFont(...) end
function guiGetColor(...) return exports.dxgui:dxGetColor(...) end
function guiGetColorCoded(...) return exports.dxgui:dxGetColorCoded(...) end
function guiGetText(...) return exports.dxgui:dxGetText(...) end
function guiGetAlpha(...) return exports.dxgui:dxGetAlpha(...) end
function guiSetPosition(...) return exports.dxgui:dxSetPosition(...) end
function guiSetSize(...) return exports.dxgui:dxSetSize(...) end
function guiSetVisible(...) return exports.dxgui:dxSetVisible(...) end
function guiSetElementTheme(...) return exports.dxgui:dxSetElementTheme(...) end
function guiSetFont(...) return exports.dxgui:dxSetFont(...) end
function guiSetColor(...) return exports.dxgui:dxSetColor(...) end
function guiSetColorCoded(...) return exports.dxgui:dxSetColorCoded(...) end
function guiSetText(...) return exports.dxgui:dxSetText(...) end
function guiSetAlpha(...) return exports.dxgui:dxSetAlpha(...) end
function guiMove(...) return exports.dxgui:dxMove(...) end
function guiRefreshStates(...) return exports.dxgui:dxRefreshStates(...) end
function guiRefreshClickStates(...) return exports.dxgui:dxRefreshClickStates(...) end
function guiAttachToDirectX(...) return dx:guiAttachToDirectX(...) end
function guiGetAlwaysOnTop(...) return exports.dxgui:dxGetAlwaysOnTop(...) end
function guiSetAlwaysOnTop(...) return exports.dxgui:dxSetAlwaysOnTop(...) end
function guiGetZOrder(...) return exports.dxgui:dxGetZOrder(...) end
function guiSetZOrder(...) return exports.dxgui:dxSetZOrder(...) end
function guiBringToFront(...) return exports.dxgui:dxBringToFront(...) end
function guiMoveToBack(...) return exports.dxgui:dxMoveToBack(...) end
function guiDestroyElement(...) return exports.dxgui:dxDestroyElement(...) end
function guiDestroyElements(...) return exports.dxgui:dxDestroyElements(...) end
function guiIsElement(...) return exports.dxgui:dxIsElement(...); end; 

-- Button.
function guiCreateButton(...) return exports.dxgui:dxCreateButton(...) end
function guiButtonRender(...) return exports.dxgui:dxButtonRender(...) end

-- CheckBox
function guiCreateCheckBox(...) return exports.dxgui:dxCreateCheckBox(...) end
function guiCheckBoxGetSelected(...) return exports.dxgui:dxCheckBoxGetSelected(...) end
function guiCheckBoxSetSelected(...) return exports.dxgui:dxCheckBoxSetSelected(...) end
function guiCheckBoxRender(...) return exports.dxgui:dxCheckBoxRender(...) end

-- Label.
function guiCreateLabel(...) return exports.dxgui:dxCreateLabel(...) end
function guiLabelGetScale(...) return exports.dxgui:dxLabelGetScale(...) end
function guiLabelGetHorizontalAlign(...) return exports.dxgui:dxLabelGetHorizontalAlign(...) end
function guiLabelGetVerticalAlign(...) return exports.dxgui:dxLabelGetVerticalAlign(...) end
function guiLabelSetScale(...) return exports.dxgui:dxLabelSetScale(...) end
function guiLabelSetHorizontalAlign(...) return exports.dxgui:dxLabelSetHorizontalAlign(...) end
function guiLabelSetVerticalAlign(...) return exports.dxgui:dxLabelSetVerticalAlign(...) end
function guiLabelRender(...) return exports.dxgui:dxLabelRender(...) end

-- ProgressBar
function guiCreateProgressBar(...) return exports.dxgui:dxCreateProgressBar(...) end
function guiProgressBarGetProgress(...) return exports.dxgui:dxProgressBarGetProgress(...) end
function guiProgressBarGetProgressPercent(...) return exports.dxgui:dxProgressBarGetProgressPercent(...) end
function guiProgressBarGetMaxProgress(...) return exports.dxgui:dxProgressBarGetMaxProgress(...) end
function guiProgressBarSetProgress(...) return exports.dxgui:dxProgressBarSetProgress(...) end
function guiProgressBarSetProgressPercent(...) return exports.dxgui:dxProgressBarSetProgressPercent(...) end
function guiProgressBarSetMaxProgress(...) return exports.dxgui:dxProgressBarSetMaxProgress(...) end
function guiProgressBarRender(...) return exports.dxgui:dxProgressBarRender(...) end

-- RadioButton
function guiCreateRadioButton(...) return exports.dxgui:dxCreateRadioButton(...) end
function guiRadioButtonGetSelected(...) return exports.dxgui:dxRadioButtonGetSelected(...) end
function guiRadioButtonGetGroup(...) return exports.dxgui:dxRadioButtonGetGroup(...) end
function guiRadioButtonSetSelected(...) return exports.dxgui:dxRadioButtonSetSelected(...) end
function guiRadioButtonSetGroup(...) return exports.dxgui:dxRadioButtonSetGroup(...) end
function guiRadioButtonRender(...) return exports.dxgui:dxRadioButtonRender(...) end

-- Scrollbar.
function guiCreateScrollBar(...) return exports.dxgui:dxCreateScrollBar(...) end
function guiScrollBarGetProgress(...) return exports.dxgui:dxScrollBarGetProgress(...) end
function guiScrollBarGetProgressPercent(...) return exports.dxgui:dxScrollBarGetProgressPercent(...) end
function guiScrollBarGetMaxProgress(...) return exports.dxgui:dxScrollBarGetMaxProgress(...) end
function guiScrollBarSetProgress(...) return exports.dxgui:dxScrollBarSetProgress(...) end
function guiScrollBarSetProgressPercent(...) return exports.dxgui:dxScrollBarSetProgressPercent(...) end
function guiScrollBarSetMaxProgress(...) return exports.dxgui:dxScrollBarSetMaxProgress(...) end
function guiScrollBarRender(...) return exports.dxgui:dxScrollBarRender(...) end
guiScrollBarGetScrollPosition = guiScrollBarGetProgressPercent
guiScrollBarSetScrollPosition = guiScrollBarSetProgressPercent

-- Spinner.
function guiCreateSpinner(...) return exports.dxgui:dxCreateSpinner(...) end
function guiSpinnerGetPosition(...) return exports.dxgui:dxSpinnerGetPosition(...) end
function guiSpinnerGetMin(...) return exports.dxgui:dxSpinnerGetMin(...) end
function guiSpinnerGetMin(...) return exports.dxgui:dxSpinnerGetMin(...) end
function guiSpinnerSetPosition(...) return exports.dxgui:dxSpinnerSetPosition(...) end
function guiSpinnerSetMin(...) return exports.dxgui:dxSpinnerSetMin(...) end
function guiSpinnerSetMin(...) return exports.dxgui:dxSpinnerSetMin(...) end
function guiSpinnerRender(...) return exports.dxgui:dxSpinnerRender(...) end

-- Static Image.
function guiCreateStaticImage(...) return exports.dxgui:dxCreateStaticImage(...) end
function guiCreateStaticImageSection(...) return exports.dxgui:dxCreateStaticImageSection(...) end
function guiStaticImageGetLoadedImage(...) return exports.dxgui:dxStaticImageGetLoadedImage(...) end
function guiStaticImageGetSection(...) return exports.dxgui:dxStaticImageGetSection(...) end
function guiStaticImageGetRotation(...) return exports.dxgui:dxStaticImageGetRotation(...) end
function guiStaticImageLoadImage(...) return exports.dxgui:dxStaticImageLoadImage(...) end
function guiStaticImageSetSection(...) return exports.dxgui:dxStaticImageSetSection(...) end
function guiStaticImageSetRotation(...) return exports.dxgui:dxStaticImageSetRotation(...) end
function guiStaticImageRender(...) return exports.dxgui:dxStaticImageRender(...) end

-- Window
function guiCreateWindow(...) return exports.dxgui:dxCreateWindow(...) end
function guiWindowGetTitlePosition(...) return exports.dxgui:dxWindowGetTitlePosition(...) end
function guiWindowGetMovable(...) return exports.dxgui:dxWindowGetMovable(...) end
function guiWindowIsMoving(...) return exports.dxgui:dxWindowIsMoving(...) end
function guiWindowGetTitleVisible(...) return exports.dxgui:dxWindowGetTitleVisible(...) end
function guiWindowSetTitlePosition(...) return exports.dxgui:dxWindowSetTitlePosition(...) end
function guiWindowSetMovable(...) return exports.dxgui:dxWindowSetMovable(...) end
function guiWindowGetTitleVisible(...) return exports.dxgui:dxWindowGetTitleVisible(...) end
function guiWindowGetPostGUI(...) return exports.dxgui:dxWindowGetPostGUI(...) end
function guiWindowSetPostGUI(...) return exports.dxgui:dxWindowSetPostGUI(...) end
function guiWindowRender(...) return exports.dxgui:dxWindowRender(...) end
function guiWindowMoveControl(...) return exports.dxgui:dxWindowMoveControl(...) end
function guiWindowComponentRender(...) return exports.dxgui:dxWindowComponentRender(...) end

-- ListBox
function guiCreateList(...) return exports.dxgui:dxCreateList(...) end
function guiListClear(...) return exports.dxgui:dxListClear(...) end
function guiListGetSelectedItem(...) return exports.dxgui:dxListGetSelectedItem(...) end
function guiListSetSelectedItem(...) return exports.dxgui:dxListSetSelectedItem(...) end
function guiListGetItemCount(...) return exports.dxgui:dxListGetItemCount(...) end
function guiListRemoveRow(...) return exports.dxgui:dxListRemoveRow(...) end
function guiListAddRow(...) return exports.dxgui:dxListAddRow(...) end
function guiListSetTitleShow(...) return exports.dxgui:dxListSetTitleShow(...) end
function guiListGetTitleShow(...) return exports.dxgui:dxListGetTitleShow(...) end
function guiListRender(...) return exports.dxgui:dxListRender(...) end

-- ComboBox = ListBox, por cuestiones de compatibilidad...
guiCreateComboBox = guiCreateList
guiComboBoxAddItem = guiListAddRow
guiComboBoxClear = guiListClear
guiComboBoxSetSelectedItem = guiListSetSelectedItem
guiComboBoxGetSelectedItem = guiListGetSelectedItem
guiComboBoxAddItem = guiListAddRow
guiComboBoxRemoveItem = guiListRemoveRow

-- EditBox
function guiCreateEdit(...) return exports.dxgui:dxCreateEdit(...); end;
function guiEditGetPlaceHolder(...) return exports.dxgui:dxEditGetPlaceHolder(...); end;
function guiEditGetCaretIndex(...) return exports.dxgui:dxEditGetCaretIndex(...); end;
function guiEditIsReadOnly(...) return exports.dxgui:dxEditIsReadOnly(...); end;
function guiEditIsMasked(...) return exports.dxgui:dxEditIsMasked(...); end;
function guiEditGetMaxLength(...) return exports.dxgui:dxEditGetMaxLength(...); end;
function guiEditSetPlaceHolder(...) return exports.dxgui:dxEditSetPlaceHolder(...); end;
function guiEditSetCaretIndex(...) return exports.dxgui:dxEditSetCaretIndex(...); end;
function guiEditSetReadOnly(...) return exports.dxgui:dxEditSetReadOnly(...); end;
function guiEditSetMasked(...) return exports.dxgui:dxEditSetMasked(...); end;
function guiEditSetMaxLength(...) return exports.dxgui:dxEditSetMaxLength(...); end;
function guiEditRender(...) return exports.dxgui:dxEditRender(...); end;

-- DrawBoard
function guiCreateDrawBoard(...) return exports.dxgui:dxCreateDrawBoard(...); end;
function guiDrawBoardGetTargetSize(...) return exports.dxgui:dxDrawBoardGetTargetSize(...); end;
function guiDrawBoardSetTargetSize(...) return exports.dxgui:dxDrawBoardSetTargetSize(...); end;

function guiDrawBoardAddHandler(drawBoard, handler) return addEventHandler("onClientDXDrawBoardRender", drawBoard, function(target) dxSetRenderTarget(target,true); handler(dxGetMaterialSize(target)); dxSetRenderTarget(); end);end;
