
export const toHexString = (byteArray) => {
    return Array.from(byteArray, function(byte) {
        return ('0' + (byte & 0xFF).toString(16)).slice(-2);
    }).join('').toUpperCase();
};

export const getAgeFromDOB = dob => {
    const birthDate = new Date(dob / 1000000);
    const ageDifMs = Date.now() - birthDate.getTime();
    const ageDate = new Date(ageDifMs);
    return Math.abs(ageDate.getUTCFullYear() - 1970);
};

export const formatDOB = dob => {
    const birthDate = new Date(dob / 1000000);
    const day = String(birthDate.getDate()).padStart(2, '0');
    const month = String(birthDate.getMonth() + 1).padStart(2, '0');
    const year = birthDate.getFullYear();
    return `${day}/${month}/${year}`;
};

export const msToTime = (duration) => {
    const seconds = Math.floor((duration / 1000) % 60);
    const minutes = Math.floor((duration / (1000 * 60)) % 60);
    const hours = Math.floor((duration / (1000 * 60 * 60)) % 24);
    const days = Math.floor(duration / (1000 * 60 * 60 * 24));

    return {
        days,
        hours,
        minutes,
        seconds
    };
};
    
export const nanoSecondsToMillis = (nanos) => {
    return Number(BigInt(nanos) / BigInt(1000000));
};

    
export const getTeamById = (teams, teamId) => {
    const team = teams.find(team => team.id === teamId);
    return team;
};


export const groupFixturesByDate = (fixtures) => {
    return fixtures.reduce((acc, fixture) => {
        const date = (new Date(nanoSecondsToMillis(fixture.kickOff))).toDateString();
        if (!acc[date]) {
            acc[date] = [];
        }
        acc[date].push(fixture);
        return acc;
    }, {});
};

export const computeTimeLeft = (kickoff) => {
    const now = new Date().getTime();
    const distance = nanoSecondsToMillis(kickoff) - now;

    return {
        days: Math.floor(distance / (1000 * 60 * 60 * 24)),
        hours: Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
        minutes: Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60)),
        seconds: Math.floor((distance % (1000 * 60)) / 1000)
    };
};

export const dateToUnixNanoseconds = (dateString) => {
    const date = new Date(dateString);
    return date.getTime() * 1000000;
};


