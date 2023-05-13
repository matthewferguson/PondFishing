# PondFishing

Contention/Crash test app for the DataFlowFunnelCD Swift Package.

PondFishing Swift Package dependency is located at https://github.com/matthewferguson/DataFlowFunnelCD . Download/Clone, open top level workspace(not projects), and verify DataFlowFunnelCD is updated automatically. If this package does not load then remove the swift package in target access area, add this swift package (URL: https://github.com/matthewferguson/DataFlowFunnelCD.git ), and once completely loaded compile and run. 

As of May 13, 2023 there are two projects running in work space.

1. PondFishing - Latest Swift, Storyboard UI, and Data Flow using Core Data through package DataFlowFunnelCD. 
2. PondFishingSwiftUI - Work in Progress (WIP) Latest Swift, SwiftUI, and Data Flow using Core Data through package DataFlowFunnelCD.

How to operate:

Pond tab (Tab View): load fish in the pond.
Fishing Boats (Tab View ): Add boats, (tap toggle) blue boats are docked and have been emptied into the Fish Market, and (tap toggle) green are out offshore fishing.
Fish Market (Tab View): When the pond fish stock hits just below 1000 all boats are unloaded in the fish market and docked waiting for the pond to be restocked with fish. 
