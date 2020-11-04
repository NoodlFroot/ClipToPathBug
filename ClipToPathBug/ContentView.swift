//
//  ContentView.swift
//  ClipToPathBug
//
//  Created by Richard Groves on 23/09/2020.
//

//MARK: See lines 66-68 for exposing and hiding the bug in the path clipping for scrollviews

import SwiftUI

// Simplest demonstration of problem of a scrollview being clipped by a Path shape based on UIBezierPath - also goes wrong with the most basic CGPath
struct TestShapeBroken: Shape
{
	func path(in rect: CGRect) -> Path
	{
		// Goes wrong with simple UIBezierPath
//		let path = UIBezierPath(rect: rect)
//		return Path(path.cgPath)
		
		// Even goes wrong with most basic CGPath
		let path = CGPath(rect: rect, transform: nil)
		return Path(path)
	}
}

// Works fine with a basic Path shape
struct TestShapeWorking: Shape
{
	func path(in rect: CGRect) -> Path
	{
		let path = Path(rect)
		return path
	}
}

struct ContentView: View
{
	@State var showSV: Bool = false
	var body: some View
	{
		// Some frames to hold the scrolling view in the middle of the screen and not be full width to demonstrate the problem more.
		HStack
		{
			Spacer()
			
			VStack
			{
				Spacer()
				
				VStack
				{
					Text("Hello, world!")
						.padding()
					
					ScrollView(.horizontal)
					{
						HStack
						{
							ForEach(1..<100)
							{
								Text("Item \($0)")
							}
						}
						.frame(minWidth: 75.0)
					}
				}
				.background(Color.white)
				.frame(minHeight: 250.0)
				.frame(maxWidth: 300.0)
				//.clipShape(Circle()) // This works - all scrollview text appears
				//.clipShape(TestShapeWorking()) // Works
				.clipShape(TestShapeBroken()) // Doesn't work
				
				Spacer()
			}
			.background(Color.green)
			
			Spacer()
		}
		.background(Color.purple)
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
