function mapclass_tomatos = create_mapping_tomatos()
keySet_tomatos = [1:11];
valueSet_tomatos = cell (numel(keySet_tomatos), 1);
for i=1:numel(keySet_tomatos)
    final_class_temp = sprintf('%05d', keySet_tomatos(i));
    valueSet_tomatos{i} = ['prod' final_class_temp '000'];
end
mapclass_tomatos = containers.Map(keySet_tomatos,valueSet_tomatos);
