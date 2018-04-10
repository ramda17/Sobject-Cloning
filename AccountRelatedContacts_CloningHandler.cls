public with sharing class AccountRelatedContacts_CloningHandler {

    static String entityType;
    public static final String COMMA_SEPARATION = ',';
    public static final String SPACE = ' ';

    public static void cloningHandlerMethod(List<SObject> newSObjList) {   //List<SObject> newSObjList
        Map<Id, Set<Id>> sourceIdAndRelatedTargetIdsMap = new Map<Id, Set<Id>>(); //sourceIdAndRelatedTargetIdsMap
        for(SObject sobj : newSObjList) { //newSObjList
            if(!sobj.isClone()) {
                System.debug('@ramda===>was not a clone');
                continue;
            }
            Id cloneSourceId = sobj.getCloneSourceId();

            //Based upon the Id determine the Entity (or Object) type
            entityType = String.valueOf(cloneSourceId.getSObjectType());

            if(!sourceIdAndRelatedTargetIdsMap.containsKey(cloneSourceId)) {
                sourceIdAndRelatedTargetIdsMap.put(cloneSourceId,new Set<Id>{sobj.Id});
            } else {
                sourceIdAndRelatedTargetIdsMap.get(cloneSourceId).add(sobj.Id);
            }
        }
        AccountRelatedContacts_CloningHandler.create_RelatedCloneSObject_ForClonedSObject(sourceIdAndRelatedTargetIdsMap); //sourceIdAndRelatedTargetIdsMap
    }

    public static void create_RelatedCloneSObject_ForClonedSObject(Map<Id,Set<Id>> sourceIdAndRelatedTargetIdsMap) {
        System.debug('Entity Type ==> '+ entityType);

        if(null == sourceIdAndRelatedTargetIdsMap) {
            return;
        }
        // List<SObject> relatedRecordList =

        List<SObject> finalClonedRelatedSObjectList = fetchSObjectRecords(sourceIdAndRelatedTargetIdsMap);  //List<SObject>

        if(false == finalClonedRelatedSObjectList.isEmpty()) {
            insert finalClonedRelatedSObjectList;
        }
    }


    public static List<SObject> fetchSObjectRecords(Map<Id,Set<Id>> sourceIdAndRelatedTargetIdsMap) {

        List<SObject> finalClonedRelatedSObjectList = new List<SObject>();

        if( null == sourceIdAndRelatedTargetIdsMap) {
            return finalClonedRelatedSObjectList;
        }

        List<Clone_Custom_Setting__c> cloningConfigList = Clone_Custom_Setting__c.getAll().values();
        for(Clone_Custom_Setting__c cloningConfigObj : cloningConfigList) {
            if(cloningConfigObj.Clone_Target_Object__c == entityType) {
                finalClonedRelatedSObjectList.addAll(
                    runQuery( cloningConfigObj.Related_Child_Object__c
                            , cloningConfigObj.Parent_Relationship__c
                            , sourceIdAndRelatedTargetIdsMap
                    )
                );
            }
        }
        return finalClonedRelatedSObjectList;
    }

    public static List<SObject> runQuery( String relatedChildObject, String referenceToParent, Map<Id, Set<Id>> sourceIdAndRelatedTargetIdsMap) {

        String final_query;
        Set<Id> sourceIdAndRelatedTargetIdsMap_keySet = sourceIdAndRelatedTargetIdsMap.keySet();

        List<SObject> clonedRelatedSObjectList = new List<SObject>();
        if(null == sourceIdAndRelatedTargetIdsMap) {
            return clonedRelatedSObjectList;
        }

        final_query = 'SELECT' + SPACE
                    +  getFields(relatedChildObject)  + SPACE
                    + 'FROM' + SPACE
                    +  relatedChildObject + SPACE
                    + 'WHERE' + SPACE
                    +  referenceToParent + SPACE
                    + 'IN:' + SPACE
                    + 'sourceIdAndRelatedTargetIdsMap_keySet';

        System.debug('Final Query: ==> '+ final_query);
        List<SObject> relatedRecordList = Database.query(final_query);
        System.debug('filtered list ==> '+relatedRecordList);

        clonedRelatedSObjectList = getRelatedClonedSObjectList( referenceToParent, relatedRecordList, sourceIdAndRelatedTargetIdsMap);

        return clonedRelatedSObjectList;
    }

    public static String getFields(String relatedChildObject) {

        String sObjectfieldNames  = '';

        //get global describe and use field map
        Map<String, Schema.SObjectField> sObjFields =  Schema.getGlobalDescribe().get(relatedChildObject).getDescribe().fields.getMap();

        for(String str : sObjFields.keySet()) {
            if( true == sObjFields.get(str).getDescribe().isUpdateable()
             && true == sObjFields.get(str).getDescribe().isCreateable()) {
                sObjectfieldNames += str + COMMA_SEPARATION;
            }
        }
        sObjectfieldNames = sObjectfieldNames.removeEnd(COMMA_SEPARATION);

        return sObjectfieldNames;
    }


    public static List<SObject> getRelatedClonedSObjectList( String referenceToParent, List<Contact> relatedRecordList
    , Map<Id,Set<Id>> sourceIdAndRelatedTargetIdsMap) {

        List<Sobject> clonedRelatedSObjectList = new List<SObject>();

        if( null == relatedRecordList
         && null == sourceIdAndRelatedTargetIdsMap) {
            return clonedRelatedSObjectList;
        }
        for(SObject sobj : relatedRecordList) {
            System.debug('sobject@==>'+sobj);
            for(Id clonedSObjId : sourceIdAndRelatedTargetIdsMap.get((Id)sobj.get(referenceToParent)) ) { //sobj.get() returns an object
                // sObject sObjToInsert = Schema.getGlobalDescribe().get(entityType).newSObject() ;
                SObject sObjToInsert = sobj.clone(false, true, true, true);
                sObjToInsert.put(referenceToParent, clonedSObjId);
                clonedRelatedSObjectList.add(sObjToInsert);
            }
         }
         System.debug('clonedRelatedSObjectList ==> '+clonedRelatedSObjectList);
         return clonedRelatedSObjectList;
    }

    // public static Set<Id> fetchclonedSObjectSet(Map<Id,Set<Id>> sourceIdAndRelatedTargetIdsMap, Set<Id> clonedSObjectSet) {
    //
    //     if( null == sourceIdAndRelatedTargetIdsMap
    //      && null == clonedSObjectSet) {
    //         return new Set<Id>();
    //     }
    //     //Iterate over the cloned Account list
    //     for(Id cloneSourceId : sourceIdAndRelatedTargetIdsMap.keySet()) {
    //         for(Id clonedSObjId : sourceIdAndRelatedTargetIdsMap.get(cloneSourceId)) {
    //             clonedSObjectSet.add(clonedSObjId);
    //         }
    //     }
    //     if(true == clonedSObjectSet.isEmpty()) {
    //         return new Set<Id>();
    //     } else {
    //         return clonedSObjectSet;
    //     }
    // }


}