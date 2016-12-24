function mapclass_cereal = create_mapping_cereal()
keySet_cereal = [1:65];
valueSet_cereal = cell (numel(keySet_cereal), 1);
for i=1:numel(keySet_cereal)
    final_class_temp = sprintf('%05d', keySet_cereal(i));
    valueSet_cereal{i} = ['prod' final_class_temp '000'];
end
mapclass_cereal = containers.Map(keySet_cereal,valueSet_cereal);
