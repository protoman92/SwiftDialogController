# SwiftDialogController

![](https://travis-ci.org/protoman92/SwiftDialogController.svg?branch=master)

**UIViewController** that can be presented on top of another **UIViewController**, with behaviors similar to Android's **DialogFragment**.

## Presets:

**UIView** instances that will be added as the main dialog view should implement one of these three preset protocols:

### PaddingDialogViewType: 

Represents a **UIView** that has top/bottom and left/right margins relative to its parent **UIView**. Once a **UIView** implements this protocol, it will have to declare **longSidePadding** and **shortSidePadding**. As the name suggests, the distinction between long and short sides depends on the app's orientation; e.g. if the app is in portrait mode, the long side will be its height, and the long-side NSLayoutAttribute will be top and bottom.

### RatioDialogViewType: 

Similar to **PaddingDialogViewType**, but instead of concrete margins, we use a multiplier to anchor the dialog **UIView** to its parent **UIView**. **UIView** that implements this protocol must declare **longSideRatio** and **shortSideRatio**, so that in portrait mode, the long side will be the device's height and the short side its width (vice versa for landscape).

### RatioPaddingDialogViewType: 

A mix of the above protocols, with **longSideRatio** and **shortSidePadding**, since this combination is the most sensible.

## Custom:

If we want to customize how a **UIView** is added to the **UIDialogController**'s main view, we need to implement **DialogViewType** (the base protocol that all the above protocols inherit from) and **ViewBuilderType** - to provide constraints for the view building process.
