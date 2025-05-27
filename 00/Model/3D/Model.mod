'# MWS Version: Version 2022.4 - Apr 26 2022 - ACIS 31.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 4 fmax = 20
'# created = '[VERSION]2022.4|31.0.1|20220426[/VERSION]


'@ use template: FSS, Metamaterial - Unit Cell.cfg

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "NanoH"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "PikoF"
End With

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .Rho "1.204"
     .ThermalType "Normal"
     .ThermalConductivity "0.026"
      .SpecificHeat "1005", "J/K/kg"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

' define Floquet port boundaries

With FloquetPort
     .Reset
     .SetDialogTheta "0"
     .SetDialogPhi "0"
     .SetSortCode "+beta/pw"
     .SetCustomizedListFlag "False"
     .Port "Zmin"
     .SetNumberOfModesConsidered "2"
     .Port "Zmax"
     .SetNumberOfModesConsidered "2"
End With

MakeSureParameterExists "theta", "0"
SetParameterDescription "theta", "spherical angle of incident plane wave"
MakeSureParameterExists "phi", "0"
SetParameterDescription "phi", "spherical angle of incident plane wave"

' define boundaries, the open boundaries define floquet port

With Boundary
     .Xmin "unit cell"
     .Xmax "unit cell"
     .Ymin "unit cell"
     .Ymax "unit cell"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .XPeriodicShift "0.0"
     .YPeriodicShift "0.0"
     .ZPeriodicShift "0.0"
     .PeriodicUseConstantAngles "False"
     .SetPeriodicBoundaryAngles "theta", "phi"
     .SetPeriodicBoundaryAnglesDirection "inward"
     .UnitCellFitToBoundingBox "True"
     .UnitCellDs1 "0.0"
     .UnitCellDs2 "0.0"
     .UnitCellAngle "90.0"
End With

' set tet mesh as default

With Mesh
     .MeshType "Tetrahedral"
End With

' FD solver excitation with incoming plane wave at Zmax

With FDSolver
     .Reset
     .Stimulation "List", "List"
     .ResetExcitationList
     .AddToExcitationList "Zmax", "TE(0,0);TM(0,0)"
     .LowFrequencyStabilization "False"
End With

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "Tetrahedral"
End With

'set the solver type
ChangeSolverType("HF Frequency Domain")

'----------------------------------------------------------------------------

'@ define material: PET

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material 
     .Reset 
     .Name "PET"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "1"
     .Mu "1"
     .Sigma "0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0", "1", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ new component: component1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Component.New "component1"

'@ define brick: component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "PET" 
     .Xrange "-P/2", "P/2" 
     .Yrange "-P/2", "P/2" 
     .Zrange "0", "tp2" 
     .Create
End With

'@ define material: Air

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material
     .Reset
     .Name "Air"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "Hz", "mm"
.Epsilon "1.00059"
.Mu "1.0"
.Kappa "0"
.TanD "0.0"
.TanDFreq "0.0"
.TanDGiven "False"
.TanDModel "ConstKappa"
.KappaM "0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "1.204"
.ThermalType "Normal"
.ThermalConductivity "0.026"
.SpecificHeat "1005", "J/K/kg"
.SetActiveMaterial "all"
.Colour "0.682353", "0.717647", "1"
.Wireframe "False"
.Transparency "0"
.Create
End With

'@ define brick: component1:solid2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "Air" 
     .Xrange "-14.2/2", "14.2/2" 
     .Yrange "-14.2/2", "14.2/2" 
     .Zrange "0.15", "0.15+5.8" 
     .Create
End With

'@ define brick: component1:solid3

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "solid3" 
     .Component "component1" 
     .Material "PET" 
     .Xrange "-14.2/2", "14.2/2" 
     .Yrange "-14.2/2", "14.2/2" 
     .Zrange "0.15+5.8", "0.15+5.8+0.05" 
     .Create
End With

'@ define curve circle: curve1:circle1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Circle
     .Reset 
     .Name "circle1" 
     .Curve "curve1" 
     .Radius "7.4" 
     .Xcenter "0.0" 
     .Ycenter "0.0" 
     .Segments "0" 
     .Create
End With

'@ delete curve: curve1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Curve.DeleteCurve "curve1"

'@ define monitor: e-field (f=0e+)

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=0e+)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "0" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-8.6", "8.6", "-8.6", "8.6", "0", "6" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: e-field (f=0e+)

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Monitor.Delete "e-field (f=0e+)"

'@ define frequency range

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solver.FrequencyRange "2", "20"

'@ define frequency domain solver parameters

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "List", "List" 
     .ResetExcitationList 
     .AddToExcitationList "Zmax", "TE(0,0);TM(0,0)" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "False" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseEnhancedCFIE2 "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .UseEnhancedNFSImprint "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
     .DetectThinDielectrics "True" 
End With

'@ define material: ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material 
     .Reset 
     .Name "ITO"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .OhmicSheetImpedance "100", "0"
     .OhmicSheetFreq "0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0.501961", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material: ground

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material 
     .Reset 
     .Name "ground"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .OhmicSheetImpedance "0.2", "0"
     .OhmicSheetFreq "0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material: PET

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material 
     .Reset 
     .Name "PET"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "3"
     .Mu "1"
     .Sigma "0"
     .TanD "0.06"
     .TanDFreq "10"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0", "1", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ rename block: component1:solid1 to: component1:1pet

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:solid1", "1pet"

'@ rename block: component1:solid3 to: component1:3pet

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:solid3", "3pet"

'@ rename block: component1:solid2 to: component1:2air

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:solid2", "2air"

'@ define brick: component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "ground" 
     .Xrange "-14.2/2", "14.2/2" 
     .Yrange "-14.2/2", "14.2/2" 
     .Zrange "0", "0" 
     .Create
End With

'@ rename block: component1:solid1 to: component1:1ground

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:solid1", "1ground"

'@ define cylinder: component1:3UP

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Cylinder 
     .Reset 
     .Name "3UP" 
     .Component "component1" 
     .Material "ground" 
     .OuterRadius "7.4" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "6", "6" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ change material: component1:3UP to: ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.ChangeMaterial "component1:3UP", "ITO"

'@ define cylinder: component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "ITO" 
     .OuterRadius "3.3" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "6", "6" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ transform: translate component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1" 
     .Vector "0", "5.2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: rotate component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "3" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ define frequency range

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solver.FrequencyRange "4", "20"

'@ define Floquet port boundaries

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With FloquetPort
     .Reset
     .SetDialogTheta "0" 
     .SetDialogPhi "0" 
     .SetPolarizationIndependentOfScanAnglePhi "0.0", "False"  
     .SetSortCode "+beta/pw" 
     .SetCustomizedListFlag "False" 
     .Port "Zmin" 
     .SetNumberOfModesConsidered "2" 
     .SetDistanceToReferencePlane "-75/12" 
     .SetUseCircularPolarization "False" 
     .Port "Zmax" 
     .SetNumberOfModesConsidered "2" 
     .SetDistanceToReferencePlane "-75/12" 
     .SetUseCircularPolarization "False" 
End With

'@ delete shapes

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Delete "component1:3UP" 
Solid.Delete "component1:solid1" 
Solid.Delete "component1:solid1_1" 
Solid.Delete "component1:solid1_2" 
Solid.Delete "component1:solid1_3"

'@ rename block: component1:1ground to: component1:1ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:1ground", "1ITO"

'@ delete shape: component1:1ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Delete "component1:1ITO"

'@ new component: component1/component1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Component.New "component1/component1"

'@ delete component: component1/component1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Component.Delete "component1/component1"

'@ define brick: component1:1ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "1ITO" 
     .Component "component1" 
     .Material "PET" 
     .Xrange "-14.2/2", "14.2/2" 
     .Yrange "-14.2/2", "14.2/2" 
     .Zrange "0", "0" 
     .Create
End With

'@ delete shapes

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Delete "component1:2air" 
Solid.Delete "component1:3pet"

'@ define material: material1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material 
     .Reset 
     .Name "material1"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "2.25"
     .Mu "1"
     .Sigma "0"
     .TanD "0.001"
     .TanDFreq "10"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.501961", "0.501961", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define brick: component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "material1" 
     .Xrange "-14.2/2", "14.2/2" 
     .Yrange "-14.2/2", "14.2/2" 
     .Zrange "0.175", "0.175+h2" 
     .Create
End With

'@ rename material: material1 to: PMMA

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Material.Rename "material1", "PMMA"

'@ rename block: component1:solid1 to: component1:2PMMA

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:solid1", "2PMMA"

'@ define brick: component1:3ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "3ITO" 
     .Component "component1" 
     .Material "ITO" 
     .Xrange "-14.2/2", "14.2/2" 
     .Yrange "-14.2/2", "14.2/2" 
     .Zrange "0.175+h2", "0.175+h2" 
     .Create
End With

'@ define brick: component1:3pet

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "3pet" 
     .Component "component1" 
     .Material "PET" 
     .Xrange "-P/2", "P/2" 
     .Yrange "-P/2", "P/2" 
     .Zrange "tp2+ta", "tp2+ta+tp1" 
     .Create
End With

'@ define material colour: ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material 
     .Name "ITO"
     .Folder ""
     .Colour "1", "0.501961", "0.501961" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ delete shape: component1:3ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Delete "component1:3ITO"

'@ define curve rectangle: curve1:rectangle1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Rectangle
     .Reset 
     .Name "rectangle1" 
     .Curve "curve1" 
     .Xrange "-3.33/2", "3.33/2" 
     .Yrange "-3.33/2", "3.33/2" 
     .Create
End With

'@ define curve rectangle: curve1:rectangle2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Rectangle
     .Reset 
     .Name "rectangle2" 
     .Curve "curve1" 
     .Xrange "-4.1/2", "4.1/2" 
     .Yrange "-4.1/2", "4.1/2" 
     .Create
End With

'@ store picked point: 1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Pick.NextPickToDatabase "1" 
Pick.PickCurveEndpointFromId "curve1:rectangle2", "4"

'@ define curve rectangle: curve1:rectangle3

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Rectangle
     .Reset 
     .Name "rectangle3" 
     .Curve "curve1" 
     .Xrange "-3.33/2", "3.33/2" 
     .Yrange "-3.33/2", "3.33/2" 
     .Create
End With

'@ delete curve items

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Curve.DeleteCurveItem "curve1", "rectangle1" 
Curve.DeleteCurveItem "curve1", "rectangle2"

'@ define curve rectangle: curve1:rectangle4

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Rectangle
     .Reset 
     .Name "rectangle4" 
     .Curve "curve1" 
     .Xrange "-4.1/2", "4.1/2" 
     .Yrange "-4.1/2", "4.1/2" 
     .Create
End With

'@ transform curve: translate curve1:rectangle3

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:rectangle3" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Transform "Curve", "Translate" 
End With

'@ transform curve: translate curve1:rectangle4

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:rectangle4" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ define coverprofile: component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With CoverCurve
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "ITO" 
     .Curve "curve1:rectangle3" 
     .DeleteCurve "True" 
     .Create
End With

'@ define coverprofile: component1:solid2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With CoverCurve
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "ITO" 
     .Curve "curve1:rectangle4" 
     .DeleteCurve "True" 
     .Create
End With

'@ boolean subtract shapes: component1:solid2, component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Subtract "component1:solid2", "component1:solid1"

'@ rename block: component1:solid2 to: component1:ITO-inner

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:solid2", "ITO-inner"

'@ define curve circle: curve1:circle1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Circle
     .Reset 
     .Name "circle1" 
     .Curve "curve1" 
     .Radius "3.35" 
     .Xcenter "0.0" 
     .Ycenter "0.0" 
     .Segments "0" 
     .Create
End With

'@ delete curve item: curve1:circle1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Curve.DeleteCurveItem "curve1", "circle1"

'@ define curve arc: curve1:arc1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Arc
     .Reset 
     .Name "arc1" 
     .Curve "curve1" 
     .Orientation "Clockwise" 
     .XCenter "0" 
     .YCenter "0" 
     .X1 "3.35" 
     .Y1 "0.0" 
     .X2 "0.0" 
     .Y2 "0.0" 
     .Angle "180" 
     .UseAngle "True" 
     .Segments "0" 
     .Create
End With

'@ transform curve: translate curve1:arc1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:arc1" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ define curve arc: curve1:arc2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Arc
     .Reset 
     .Name "arc2" 
     .Curve "curve1" 
     .Orientation "Clockwise" 
     .XCenter "0" 
     .YCenter "0" 
     .X1 "3.35+0.43" 
     .Y1 "0.0" 
     .X2 "0.0" 
     .Y2 "0.0" 
     .Angle "180" 
     .UseAngle "True" 
     .Segments "0" 
     .Create
End With

'@ transform curve: translate curve1:arc2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:arc2" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ define curve line: curve1:line1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "3.35+0.43" 
     .Y1 "0.0" 
     .X2 "-3.35-0.43" 
     .Y2 "0.0" 
     .Create
End With

'@ transform curve: translate curve1:line1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:line1" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ define coverprofile: component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With CoverCurve
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "ITO" 
     .Curve "curve1:arc2" 
     .DeleteCurve "True" 
     .Create
End With

'@ define curve line: curve1:line1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "3.35" 
     .Y1 "0.0" 
     .X2 "-3.35" 
     .Y2 "0.0" 
     .Create
End With

'@ transform curve: translate curve1:line1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:line1" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ define coverprofile: component1:solid2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With CoverCurve
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "ITO" 
     .Curve "curve1:arc1" 
     .DeleteCurve "True" 
     .Create
End With

'@ boolean subtract shapes: component1:solid1, component1:solid2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Subtract "component1:solid1", "component1:solid2"

'@ rename block: component1:solid1 to: component1:arc

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:solid1", "arc"

'@ rename block: component1:arc to: component1:ITO-arc

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:arc", "ITO-arc"

'@ transform: rotate component1:ITO-arc

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ITO-arc" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: rotate component1:ITO-arc_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ITO-arc_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: rotate component1:ITO-arc_1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ITO-arc_1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: translate component1:ITO-arc

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ITO-arc" 
     .Vector "0", "13.15/2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:ITO-arc_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ITO-arc_1" 
     .Vector "-13.15/2", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:ITO-arc_1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ITO-arc_1_1" 
     .Vector "0", "-13.15/2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:ITO-arc_1_1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ITO-arc_1_1_1" 
     .Vector "13.15/2", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ define curve line: curve1:line1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "13.15/2" 
     .Y1 "13.15/2" 
     .X2 "-13.15/2" 
     .Y2 "13.15/2" 
     .Create
End With

'@ define curve line: curve1:line2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Line
     .Reset 
     .Name "line2" 
     .Curve "curve1" 
     .X1 "13.15/2" 
     .Y1 "13.15/2-0.43" 
     .X2 "-13.15/2" 
     .Y2 "13.15/2-0.43" 
     .Create
End With

'@ transform curve: translate curve1:line1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:line1" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Transform "Curve", "Translate" 
End With

'@ transform curve: translate curve1:line2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:line2" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ define curve line: curve1:line3

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Line
     .Reset 
     .Name "line3" 
     .Curve "curve1" 
     .X1 "13.15/2" 
     .Y1 "13.15/2" 
     .X2 "13.15/2" 
     .Y2 "13.15/2-0.43" 
     .Create
End With

'@ transform curve: translate curve1:line3

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:line3" 
     .Vector "0", "0", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ transform curve: translate curve1:line3

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:line3" 
     .Vector "-13.15", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Transform "Curve", "Translate" 
End With

'@ define coverprofile: component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With CoverCurve
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "ITO" 
     .Curve "curve1:line1" 
     .DeleteCurve "True" 
     .Create
End With

'@ define curve rectangle: curve1:rectangle1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Rectangle
     .Reset 
     .Name "rectangle1" 
     .Curve "curve1" 
     .Xrange "-3.35", "3.35" 
     .Yrange "0", "0.43" 
     .Create
End With

'@ transform curve: translate curve1:rectangle1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "curve1:rectangle1" 
     .Vector "0", "13.15/2-0.43", "0.175+h2" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Curve", "Translate" 
End With

'@ define coverprofile: component1:solid2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With CoverCurve
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "ITO" 
     .Curve "curve1:rectangle1" 
     .DeleteCurve "True" 
     .Create
End With

'@ boolean subtract shapes: component1:solid1, component1:solid2

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Subtract "component1:solid1", "component1:solid2"

'@ transform: rotate component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: rotate component1:solid1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: rotate component1:solid1_1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .AutoDestination "True" 
     .Transform "Shape", "Rotate" 
End With

'@ boolean add shapes: component1:ITO-arc, component1:ITO-arc_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Add "component1:ITO-arc", "component1:ITO-arc_1"

'@ boolean add shapes: component1:ITO-arc_1_1, component1:ITO-arc_1_1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Add "component1:ITO-arc_1_1", "component1:ITO-arc_1_1_1"

'@ boolean add shapes: component1:solid1, component1:solid1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1"

'@ boolean add shapes: component1:solid1_1_1, component1:solid1_1_1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Add "component1:solid1_1_1", "component1:solid1_1_1_1"

'@ boolean add shapes: component1:ITO-arc, component1:ITO-arc_1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Add "component1:ITO-arc", "component1:ITO-arc_1_1"

'@ boolean add shapes: component1:solid1, component1:solid1_1_1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Add "component1:solid1", "component1:solid1_1_1"

'@ boolean add shapes: component1:ITO-arc, component1:solid1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Add "component1:ITO-arc", "component1:solid1"

'@ rename block: component1:ITO-arc to: component1:ITO-outer

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:ITO-arc", "ITO-outer"

'@ define Floquet port boundaries

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With FloquetPort
     .Reset
     .SetDialogTheta "0" 
     .SetDialogPhi "0" 
     .SetPolarizationIndependentOfScanAnglePhi "0.0", "False"  
     .SetSortCode "+beta/pw" 
     .SetCustomizedListFlag "False" 
     .Port "Zmin" 
     .SetNumberOfModesConsidered "2" 
     .SetDistanceToReferencePlane "-75/13" 
     .SetUseCircularPolarization "False" 
     .Port "Zmax" 
     .SetNumberOfModesConsidered "2" 
     .SetDistanceToReferencePlane "-75/13" 
     .SetUseCircularPolarization "False" 
End With

'@ define material: ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material 
     .Reset 
     .Name "ITO"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .OhmicSheetImpedance "20", "0"
     .OhmicSheetFreq "0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0.501961", "0.501961" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ delete shape: component1:1ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Delete "component1:1ITO"

'@ define brick: component1:1ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "1ITO" 
     .Component "component1" 
     .Material "ITO" 
     .Xrange "-P/2", "P/2" 
     .Yrange "-P/2", "P/2" 
     .Zrange "0", "0" 
     .Create
End With

'@ define Floquet port boundaries

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With FloquetPort
     .Reset
     .SetDialogTheta "0" 
     .SetDialogPhi "0" 
     .SetPolarizationIndependentOfScanAnglePhi "0.0", "False"  
     .SetSortCode "+beta/pw" 
     .SetCustomizedListFlag "False" 
     .Port "Zmin" 
     .SetNumberOfModesConsidered "2" 
     .SetDistanceToReferencePlane "-75/12" 
     .SetUseCircularPolarization "False" 
     .Port "Zmax" 
     .SetNumberOfModesConsidered "2" 
     .SetDistanceToReferencePlane "-75/12" 
     .SetUseCircularPolarization "False" 
End With

'@ rename block: component1:1ITO to: component1:1Cu

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Rename "component1:1ITO", "1Cu"

'@ delete shape: component1:1Cu

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Delete "component1:1Cu"

'@ define brick: component1:1Cu

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "1Cu" 
     .Component "component1" 
     .Material "ground" 
     .Xrange "-P/2", "P/2" 
     .Yrange "-P/2", "P/2" 
     .Zrange "0", "0" 
     .Create
End With

'@ delete shape: component1:2PMMA

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Delete "component1:2PMMA"

'@ define brick: component1:2Air_spacer

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Brick
     .Reset 
     .Name "2Air_spacer" 
     .Component "component1" 
     .Material "Air" 
     .Xrange "-P/2", "P/2" 
     .Yrange "-P/2", "P/2" 
     .Zrange "tp2", "tp2+ta" 
     .Create
End With

'@ delete shapes

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
Solid.Delete "component1:ITO-inner" 
Solid.Delete "component1:ITO-outer"

'@ paste structure data: 1

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With SAT 
     .Reset 
     .FileName "*1.cby" 
     .SubProjectScaleFactor "0.001" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With 

With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_0_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_0_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_1_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_1_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_2_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_2_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_3_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_3_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_4_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_0_4_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_0_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_0_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_1_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_1_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_2_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_2_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_3_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_3_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_4_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_1_4_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_0_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_0_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_1_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_1_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_2_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_2_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_3_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_3_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_4_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_2_4_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_0_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_0_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_1_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_1_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_2_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_2_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_3_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_3_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_4_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_3_4_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_0_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_0_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_1_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_1_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_2_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_2_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_3_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_3_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_4_1")
          .SetMeshType "All" 
          .Set "Transform", "6.12323e-17", "-1", "0", "1", "6.12323e-17", "0", "0", "0", "1" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1:Cell_4_4_2")
          .SetMeshType "All" 
          .Set "Transform", "-1.83697e-16", "1", "0", "-1", "-1.83697e-16", "0", "0", "0", "1" 
     End With
End With

''@ transform: rotate component1:Cell_0_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "90" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "270" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_0_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_0_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_1_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_1_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_2_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_2_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_3_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_3_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_0
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_0" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_1
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_2
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_2" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_3
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_3" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ transform: rotate component1:Cell_4_4
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:Cell_4_4" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .Angle "0", "0", "180" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .Destination "" 
'     .Material "" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Rotate" 
'End With
'
''@ change material: component1:Cell_0_0 to: PET
'
''[VERSION]2022.4|31.0.1|20220426[/VERSION]
'Solid.ChangeMaterial "component1:Cell_0_0", "PET"
'
'@ define material: ITO

'[VERSION]2022.4|31.0.1|20220426[/VERSION]
With Material 
     .Reset 
     .Name "ITO"
     .Folder ""
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .IntrinsicCarrierDensity "0"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .OhmicSheetImpedance "R1", "0"
     .OhmicSheetFreq "0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0.501961", "0.501961" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

