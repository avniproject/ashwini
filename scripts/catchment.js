


function mappings(row){
if(mapped[row[2]] == null){
mapped[row[2]] = {};
mapped[row[2]].uuid = uuidv4();
mapped[row[2]].name = row[2];
mapped[row[2]].type = 'Area';
mapped[row[2]].addressLevels = [];
}
mapped[row[2]].addressLevels.push({uuid:uuidv4(),level:1,name:row[1],type:'Village'});
}


fs.writeFileSync('/openchs/ashwini/catchments.json',JSON.stringify(mapped, null, 2))