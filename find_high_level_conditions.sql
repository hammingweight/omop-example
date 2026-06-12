select * from concept where concept_id in
    (select descendant_concept_id from concept_ancestor
    where max_levels_of_separation != 0 and descendant_concept_id in
        (select concept_id from concept where vocabulary_id = 'SNOMED' and standard_concept='S' and domain_id='Condition')
        and descendant_concept_id not in
           (select descendant_concept_id from concept_ancestor
           where max_levels_of_separation >= 2
           and descendant_concept_id in
(              select concept_id from concept where vocabulary_id = 'SNOMED' and standard_concept='S' and domain_id='Condition')));


