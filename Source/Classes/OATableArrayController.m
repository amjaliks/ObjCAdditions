//
//  OATableArrayController.m
//  ObjCAdditions
//
//  Copyright (c) 2010 A25 SIA
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "OATableArrayController.h"


@implementation OATableArrayController

- (void)awakeFromNib {
	[tableView registerForDraggedTypes:[NSArray arrayWithObject:draggedType]];
	
	[super awakeFromNib];
}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard declareTypes:[NSArray arrayWithObject:draggedType] owner:self];
    [pboard setData:data forType:draggedType];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation {
	// accepting only drops above the row
	return operation == NSTableViewDropAbove ? NSDragOperationEvery : NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)rowIndex dropOperation:(NSTableViewDropOperation)operation {
	// retrieving source row index
	NSPasteboard *pboard = [info draggingPasteboard];
	NSData *rowData = [pboard dataForType:draggedType];
	NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	NSInteger dragRowIndex = [rowIndexes firstIndex];
	
	// if row has been moved below, row wil be inserted at (index - 1) in order to save correct sequence
	if (rowIndex > dragRowIndex) {
		rowIndex -= 1;
	}
	
	// moving object
    id object = [[self arrangedObjects] objectAtIndex:dragRowIndex];
	[self removeObjectAtArrangedObjectIndex:dragRowIndex];
	[self insertObject:object atArrangedObjectIndex:rowIndex];
	
	return YES;
}

@end
