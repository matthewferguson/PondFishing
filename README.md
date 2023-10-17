# PondFishing

Contention/Crash test app for the DataFlowFunnelCD Swift Package. This little project queues up each of the simulated fishing boats requests to prevent the aperiodic illusive Core Data contention/crash problems. The problem exist when two competing processing threads, foreground and background threads, update or create (CRUD operations) on the same Core Data managed context objects. 

PondFishing Swift Package dependency is located at https://github.com/matthewferguson/DataFlowFunnelCD . Download/Clone, open top level workspace(not projects), and verify DataFlowFunnelCD is updated automatically. If this package does not load then remove the swift package in target access area, add this swift package (URL: https://github.com/matthewferguson/DataFlowFunnelCD.git ), and once completely loaded compile and run. 

As of Oct 17, 2023 there are two projects(targets) available to run in PondFishing workspace.

1. PondFishing - Swift, Storyboard UI, and Data Flow using Core Data through package DataFlowFunnelCD. 
2. PondFishingSwiftUI - Latest Swift, SwiftUI, and Data Flow using Core Data through package DataFlowFunnelCD.

Note: Same basic architecture, but different implimentation of classes and struct Views to accomidate the new SwiftUI and it's View Model. Operations were reused to maintain a Data Flow. Latest updates to the code base are within the target 'PondFishingSwiftUI'

How to operate:

Pond tab (Tab View): load fish in the pond.
Fishing Boats (Tab View ): Add boats, (tap toggle) blue boats are docked and have been emptied into the Fish Market once the pond is under 1000 fish, and (tap toggle) green are out offshore fishing.
Fish Market (Tab View): When the pond fish stock hits just below 1000 all boats are unloaded in the fish market and docked waiting for the pond to be restocked with fish. 
