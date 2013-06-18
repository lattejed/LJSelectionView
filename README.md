![Screenshot](https://phaven-prod.s3.amazonaws.com/files/image_part/asset/946469/PdZmANHSvhINfvAj5SstpJS0vOU/medium_Screen_Shot_2013-06-18_at_3.16.38_PM.jpg "LJelectionView Screenshot")

# LJSelectionView
A common pattern in desktop Cocoa apps is to have a parent NSView manage a collection of NSView siblings. An example would be an NSView acting as a drawing canvas containing a collection of NSViews that represent lines and shapes. LJSelectionView manages those sibling views and their selection.

As of 10.5 the drawing order of sibling views is guaranteed and can be set by the `addSubview:positioned:relativeTo:` method in NSView. What we're still lacking is the ability to draw an overlay over a set of NSViews (say to draw a selection rectangle) or to directly draw in front of a NSView's subviews. 

To overcome these limitations, LJSelectionView and its supporting classes manage the subview hierarchy to allow us to draw a custom selection rectangle and custom highlights (to show what subviews have been selected). This is done transparently and the drawing styles of either can be easily customized by subclassing (or modifying) `LJSelectionItemView` and `LJSelectionRectView`. 

All included classes are configurable for common options and are easy to subclass or modify if they don't do exactly what you're looking for.
 
## Usage
Copy the four files: `LJSelectionViewController.m`, `LJSelectionView.m`, `LJSelectionItemView.m` and `LJSelectionRectView.m` and their headers to your project. Recreate the view hierarchy and make sure all outlets are hooked up in IB (you can check the demo to see how it's setup). It is possible to setup the view hierarchy without IB you just have to make sure the right connections are made.

## License
An MIT license is included in the root directory of this repo.

## Arc Support
LJSelectionView supports both ARC and non-ARC projects without modification.

## Testing
The included application tests are not automated in any way. To run the tests, open the project in Xcode and press ⌘-U.

## Forking / Copying
If you fork/copy this repo I recommend you link the `pre-commit` file in `.hooks` to your local `.git/hooks` directory. It copies the main source files and their headers from the demo project to the root directory. I didn't think a submodule was worthwhile in this case.
