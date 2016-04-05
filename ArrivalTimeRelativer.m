function RelativePhotonArrivalTime = ArrivalTimeRelativer(SteeringTimes,PhotonTimes)

SteeringTimesArray = table2array(SteeringTimes);
PhotonTimesArray = table2array(PhotonTimes);

% MaximalSteeringPeriod = max(diff(table2array(SteeringTimes)));

RelativePhotonArrivalTime = zeros(size(PhotonTimesArray));

RunningIndex = 0;

for m = 1:numel(SteeringTimesArray)-1
    TooLate = SteeringTimesArray(m+1); % if a photon arrived that late, it should be attributed to the next cycle
    RelevantPhotons = PhotonTimesArray( (PhotonTimesArray >= SteeringTimesArray(m)) & (PhotonTimesArray <TooLate));
    RelativePhotonArrivalTime(RunningIndex+1: RunningIndex + numel(RelevantPhotons)) = RelevantPhotons - SteeringTimesArray(m);
    RunningIndex = RunningIndex + numel(RelevantPhotons);
end
