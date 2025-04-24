import Ids "mo:waterway-mops/Ids";

module AllTimeHighScoreQueries = {

    public type GetAllTimeHighScores = {};

    public type AllTimeHighScores = {
        weeklyHighScore: ?HighScoreRecord;
        monthlyHighScore: ?HighScoreRecord;
        seasonHighScore: ?HighScoreRecord;
    };

    public type HighScoreRecord = {
        recordPoints: Nat16;
        recordHolderPrincipalId: Ids.PrincipalId;
        recordHolderUsername: Text;
        recordHolderProfilePicture: ?Blob;
        recordPrizePool: Nat64;
    };


};