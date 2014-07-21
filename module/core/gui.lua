
--[[!
	\file
	\brief Este módulo reemplaza las funciones estandard de la interfaz de 
	usuario de MTA, por las exportadas por el recurso dxgui. Este módulo no funcionará
	correctamente si previamente (antes de importar el módulo), el recurso dxgui 
	no está en ejecución.
]]

local dx = assert(exports.dxgui); -- dxgui debe estar en ejecución.

-- Shared.
function guiCreateRootPane(...) return dx:dxCreateRootPane(...) end
function guiGetRootPane(...) return dx:dxGetRootPane(...) end
function guiRefreshThemes(...) return dx:dxRefreshThemes(...) end
function guiGetTheme(...) return dx:dxGetTheme(...) end
function guiGetDefaultTheme(...) return dx:dxGetDefaultTheme(...) end
function guiGetPosition(...) return dx:dxGetPosition(...) end
function guiGetSize(...) return dx:dxGetSize(...) end
function guiGetVisible(...) return dx:dxGetVisible(...) end
function guiGetElementTheme(...) return dx:dxGetElementTheme(...) end
function guiGetFont(...) return dx:dxGetFont(...) end
function guiGetColor(...) return dx:dxGetColor(...) end
function guiGetColorCoded(...) return dx:dxGetColorCoded(...) end
function guiGetText(...) return dx:dxGetText(...) end
function guiGetAlpha(...) return dx:dxGetAlpha(...) end
function guiSetPosition(...) return dx:dxSetPosition(...) end
function guiSetSize(...) return dx:dxSetSize(...) end
function guiSetVisible(...) return dx:dxSetVisible(...) end
function guiSetElementTheme(...) return dx:dxSetElementTheme(...) end
function guiSetFont(...) return dx:dxSetFont(...) end
function guiSetColor(...) return dx:dxSetColor(...) end
function guiSetColorCoded(...) return dx:dxSetColorCoded(...) end
function guiSetText(...) return dx:dxSetText(...) end
function guiSetAlpha(...) return dx:dxSetAlpha(...) end
function guiMove(...) return dx:dxMove(...) end
function guiRefreshStates(...) return dx:dxRefreshStates(...) end
function guiRefreshClickStates(...) return dx:dxRefreshClickStates(...) end
function guiAttachToDirectX(...) return dx:guiAttachToDirectX(...) end
function guiGetAlwaysOnTop(...) return dx:dxGetAlwaysOnTop(...) end
function guiSetAlwaysOnTop(...) return dx:dxSetAlwaysOnTop(...) end
function guiGetZOrder(...) return dx:dxGetZOrder(...) end
function guiSetZOrder(...) return dx:dxSetZOrder(...) end
function guiBringToFront(...) return dx:dxBringToFront(...) end
function guiMoveToBack(...) return dx:dxMoveToBack(...) end
function guiDestroyElement(...) return dx:dxDestroyElement(...) end
function guiDestroyElements(...) return dx:dxDestroyElements(...) end

-- Button.
function guiCreateButton(...) return dx:dxCreateButton(getThisResource(),...) end
function guiButtonRender(...) return dx:dxButtonRender(...) end

-- CheckBox
function guiCreateCheckBox(...) return dx:dxCreateCheckBox(getThisResource(),...) end
function guiCheckBoxGetSelected(...) return dx:dxCheckBoxGetSelected(...) end
function guiCheckBoxSetSelected(...) return dx:dxCheckBoxSetSelected(...) end
function guiCheckBoxRender(...) return dx:dxCheckBoxRender(...) end

-- Label.
function guiCreateLabel(...) return dx:dxCreateLabel(getThisResource(),...) end
function guiLabelGetScale(...) return dx:dxLabelGetScale(...) end
function guiLabelGetHorizontalAlign(...) return dx:dxLabelGetHorizontalAlign(...) end
function guiLabelGetVerticalAlign(...) return dx:dxLabelGetVerticalAlign(...) end
function guiLabelSetScale(...) return dx:dxLabelSetScale(...) end
function guiLabelSetHorizontalAlign(...) return dx:dxLabelSetHorizontalAlign(...) end
function guiLabelSetVerticalAlign(...) return dx:dxLabelSetVerticalAlign(...) end
function guiLabelRender(...) return dx:dxLabelRender(...) end

-- ProgressBar
function guiCreateProgressBar(...) return dx:dxCreateProgressBar(getThisResource(),...) end
function guiProgressBarGetProgress(...) return dx:dxProgressBarGetProgress(...) end
function guiProgressBarGetProgressPercent(...) return dx:dxProgressBarGetProgressPercent(...) end
function guiProgressBarGetMaxProgress(...) return dx:dxProgressBarGetMaxProgress(...) end
function guiProgressBarSetProgress(...) return dx:dxProgressBarSetProgress(...) end
function guiProgressBarSetProgressPercent(...) return dx:dxProgressBarSetProgressPercent(...) end
function guiProgressBarSetMaxProgress(...) return dx:dxProgressBarSetMaxProgress(...) end
function guiProgressBarRender(...) return dx:dxProgressBarRender(...) end

-- RadioButton
function guiCreateRadioButton(...) return dx:dxCreateRadioButton(getThisResource(),...) end
function guiRadioButtonGetSelected(...) return dx:dxRadioButtonGetSelected(...) end
function guiRadioButtonGetGroup(...) return dx:dxRadioButtonGetGroup(...) end
function guiRadioButtonSetSelected(...) return dx:dxRadioButtonSetSelected(...) end
function guiRadioButtonSetGroup(...) return dx:dxRadioButtonSetGroup(...) end
function guiRadioButtonRender(...) return dx:dxRadioButtonRender(...) end

-- Scrollbar.
function guiCreateScrollBar(...) return dx:dxCreateScrollBar(getThisResource(),...) end
function guiScrollBarGetProgress(...) return dx:dxScrollBarGetProgress(...) end
function guiScrollBarGetProgressPercent(...) return dx:dxScrollBarGetProgressPercent(...) end
function guiScrollBarGetMaxProgress(...) return dx:dxScrollBarGetMaxProgress(...) end
function guiScrollBarSetProgress(...) return dx:dxScrollBarSetProgress(...) end
function guiScrollBarSetProgressPercent(...) return dx:dxScrollBarSetProgressPercent(...) end
function guiScrollBarSetMaxProgress(...) return dx:dxScrollBarSetMaxProgress(...) end
function guiScrollBarRender(...) return dx:dxScrollBarRender(...) end

-- Spinner.
function guiCreateSpinner(...) return dx:dxCreateSpinner(getThisResource(),...) end
function guiSpinnerGetPosition(...) return dx:dxSpinnerGetPosition(...) end
function guiSpinnerGetMin(...) return dx:dxSpinnerGetMin(...) end
function guiSpinnerGetMin(...) return dx:dxSpinnerGetMin(...) end
function guiSpinnerSetPosition(...) return dx:dxSpinnerSetPosition(...) end
function guiSpinnerSetMin(...) return dx:dxSpinnerSetMin(...) end
function guiSpinnerSetMin(...) return dx:dxSpinnerSetMin(...) end
function guiSpinnerRender(...) return dx:dxSpinnerRender(...) end

-- Static Image.
function guiCreateStaticImage(...) return dx:dxCreateStaticImage(getThisResource(),...) end
function guiCreateStaticImageSection(...) return dx:dxCreateStaticImageSection(...) end
function guiStaticImageGetLoadedImage(...) return dx:dxStaticImageGetLoadedImage(...) end
function guiStaticImageGetSection(...) return dx:dxStaticImageGetSection(...) end
function guiStaticImageGetRotation(...) return dx:dxStaticImageGetRotation(...) end
function guiStaticImageLoadImage(...) return dx:dxStaticImageLoadImage(...) end
function guiStaticImageSetSection(...) return dx:dxStaticImageSetSection(...) end
function guiStaticImageSetRotation(...) return dx:dxStaticImageSetRotation(...) end
function guiStaticImageRender(...) return dx:dxStaticImageRender(...) end

-- Window
function guiCreateWindow(...) return dx:dxCreateWindow(getThisResource(),...) end
function guiWindowGetTitlePosition(...) return dx:dxWindowGetTitlePosition(...) end
function guiWindowGetMovable(...) return dx:dxWindowGetMovable(...) end
function guiWindowIsMoving(...) return dx:dxWindowIsMoving(...) end
function guiWindowGetTitleVisible(...) return dx:dxWindowGetTitleVisible(...) end
function guiWindowSetTitlePosition(...) return dx:dxWindowSetTitlePosition(...) end
function guiWindowSetMovable(...) return dx:dxWindowSetMovable(...) end
function guiWindowGetTitleVisible(...) return dx:dxWindowGetTitleVisible(...) end
function guiWindowGetPostGUI(...) return dx:dxWindowGetPostGUI(...) end
function guiWindowSetPostGUI(...) return dx:dxWindowSetPostGUI(...) end
function guiWindowRender(...) return dx:dxWindowRender(...) end<
function guiWindowMoveControl(...) return dx:dxWindowMoveControl(...) end
function guiWindowComponentRender(...) return dx:dxWindowComponentRender(...) end

-- ListBox
function guiCreateList(...) return dx:dxCreateList(getThisResource(),...) end
function guiListClear(...) return dx:dxListClear(...) end
function guiListGetSelectedItem(...) return dx:dxListGetSelectedItem(...) end
function guiListSetSelectedItem(...) return dx:dxListSetSelectedItem(...) end
function guiListGetItemCount(...) return dx:dxListGetItemCount(...) end
function guiListRemoveRow(...) return dx:dxListRemoveRow(...) end
function guiListAddRow(...) return dx:dxListAddRow(...) end
function guiListSetTitleShow(...) return dx:dxListSetTitleShow(...) end
function guiListGetTitleShow(...) return dx:dxListGetTitleShow(...) end
function guiListRender(...) return dx:dxListRender(...) end