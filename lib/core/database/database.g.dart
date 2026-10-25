// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aiSummaryMeta = const VerificationMeta(
    'aiSummary',
  );
  @override
  late final GeneratedColumn<String> aiSummary = GeneratedColumn<String>(
    'ai_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiTopicsMeta = const VerificationMeta(
    'aiTopics',
  );
  @override
  late final GeneratedColumn<String> aiTopics = GeneratedColumn<String>(
    'ai_topics',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiKeywordsMeta = const VerificationMeta(
    'aiKeywords',
  );
  @override
  late final GeneratedColumn<String> aiKeywords = GeneratedColumn<String>(
    'ai_keywords',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiDifficultyMeta = const VerificationMeta(
    'aiDifficulty',
  );
  @override
  late final GeneratedColumn<String> aiDifficulty = GeneratedColumn<String>(
    'ai_difficulty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiRelatedConceptsMeta = const VerificationMeta(
    'aiRelatedConcepts',
  );
  @override
  late final GeneratedColumn<String> aiRelatedConcepts =
      GeneratedColumn<String>(
        'ai_related_concepts',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _attachmentPathsMeta = const VerificationMeta(
    'attachmentPaths',
  );
  @override
  late final GeneratedColumn<String> attachmentPaths = GeneratedColumn<String>(
    'attachment_paths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    category,
    createdAt,
    updatedAt,
    aiSummary,
    aiTopics,
    aiKeywords,
    aiDifficulty,
    aiRelatedConcepts,
    sourceType,
    attachmentPaths,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('ai_summary')) {
      context.handle(
        _aiSummaryMeta,
        aiSummary.isAcceptableOrUnknown(data['ai_summary']!, _aiSummaryMeta),
      );
    }
    if (data.containsKey('ai_topics')) {
      context.handle(
        _aiTopicsMeta,
        aiTopics.isAcceptableOrUnknown(data['ai_topics']!, _aiTopicsMeta),
      );
    }
    if (data.containsKey('ai_keywords')) {
      context.handle(
        _aiKeywordsMeta,
        aiKeywords.isAcceptableOrUnknown(data['ai_keywords']!, _aiKeywordsMeta),
      );
    }
    if (data.containsKey('ai_difficulty')) {
      context.handle(
        _aiDifficultyMeta,
        aiDifficulty.isAcceptableOrUnknown(
          data['ai_difficulty']!,
          _aiDifficultyMeta,
        ),
      );
    }
    if (data.containsKey('ai_related_concepts')) {
      context.handle(
        _aiRelatedConceptsMeta,
        aiRelatedConcepts.isAcceptableOrUnknown(
          data['ai_related_concepts']!,
          _aiRelatedConceptsMeta,
        ),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('attachment_paths')) {
      context.handle(
        _attachmentPathsMeta,
        attachmentPaths.isAcceptableOrUnknown(
          data['attachment_paths']!,
          _attachmentPathsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      aiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_summary'],
      ),
      aiTopics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_topics'],
      ),
      aiKeywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_keywords'],
      ),
      aiDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_difficulty'],
      ),
      aiRelatedConcepts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_related_concepts'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      attachmentPaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment_paths'],
      ),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? aiSummary;
  final String? aiTopics;
  final String? aiKeywords;
  final String? aiDifficulty;
  final String? aiRelatedConcepts;
  final String sourceType;
  final String? attachmentPaths;
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.aiSummary,
    this.aiTopics,
    this.aiKeywords,
    this.aiDifficulty,
    this.aiRelatedConcepts,
    required this.sourceType,
    this.attachmentPaths,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['category'] = Variable<String>(category);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || aiSummary != null) {
      map['ai_summary'] = Variable<String>(aiSummary);
    }
    if (!nullToAbsent || aiTopics != null) {
      map['ai_topics'] = Variable<String>(aiTopics);
    }
    if (!nullToAbsent || aiKeywords != null) {
      map['ai_keywords'] = Variable<String>(aiKeywords);
    }
    if (!nullToAbsent || aiDifficulty != null) {
      map['ai_difficulty'] = Variable<String>(aiDifficulty);
    }
    if (!nullToAbsent || aiRelatedConcepts != null) {
      map['ai_related_concepts'] = Variable<String>(aiRelatedConcepts);
    }
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || attachmentPaths != null) {
      map['attachment_paths'] = Variable<String>(attachmentPaths);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      category: Value(category),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      aiSummary: aiSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(aiSummary),
      aiTopics: aiTopics == null && nullToAbsent
          ? const Value.absent()
          : Value(aiTopics),
      aiKeywords: aiKeywords == null && nullToAbsent
          ? const Value.absent()
          : Value(aiKeywords),
      aiDifficulty: aiDifficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(aiDifficulty),
      aiRelatedConcepts: aiRelatedConcepts == null && nullToAbsent
          ? const Value.absent()
          : Value(aiRelatedConcepts),
      sourceType: Value(sourceType),
      attachmentPaths: attachmentPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentPaths),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      category: serializer.fromJson<String>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      aiSummary: serializer.fromJson<String?>(json['aiSummary']),
      aiTopics: serializer.fromJson<String?>(json['aiTopics']),
      aiKeywords: serializer.fromJson<String?>(json['aiKeywords']),
      aiDifficulty: serializer.fromJson<String?>(json['aiDifficulty']),
      aiRelatedConcepts: serializer.fromJson<String?>(
        json['aiRelatedConcepts'],
      ),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      attachmentPaths: serializer.fromJson<String?>(json['attachmentPaths']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'category': serializer.toJson<String>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'aiSummary': serializer.toJson<String?>(aiSummary),
      'aiTopics': serializer.toJson<String?>(aiTopics),
      'aiKeywords': serializer.toJson<String?>(aiKeywords),
      'aiDifficulty': serializer.toJson<String?>(aiDifficulty),
      'aiRelatedConcepts': serializer.toJson<String?>(aiRelatedConcepts),
      'sourceType': serializer.toJson<String>(sourceType),
      'attachmentPaths': serializer.toJson<String?>(attachmentPaths),
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> aiSummary = const Value.absent(),
    Value<String?> aiTopics = const Value.absent(),
    Value<String?> aiKeywords = const Value.absent(),
    Value<String?> aiDifficulty = const Value.absent(),
    Value<String?> aiRelatedConcepts = const Value.absent(),
    String? sourceType,
    Value<String?> attachmentPaths = const Value.absent(),
  }) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    aiSummary: aiSummary.present ? aiSummary.value : this.aiSummary,
    aiTopics: aiTopics.present ? aiTopics.value : this.aiTopics,
    aiKeywords: aiKeywords.present ? aiKeywords.value : this.aiKeywords,
    aiDifficulty: aiDifficulty.present ? aiDifficulty.value : this.aiDifficulty,
    aiRelatedConcepts: aiRelatedConcepts.present
        ? aiRelatedConcepts.value
        : this.aiRelatedConcepts,
    sourceType: sourceType ?? this.sourceType,
    attachmentPaths: attachmentPaths.present
        ? attachmentPaths.value
        : this.attachmentPaths,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      aiSummary: data.aiSummary.present ? data.aiSummary.value : this.aiSummary,
      aiTopics: data.aiTopics.present ? data.aiTopics.value : this.aiTopics,
      aiKeywords: data.aiKeywords.present
          ? data.aiKeywords.value
          : this.aiKeywords,
      aiDifficulty: data.aiDifficulty.present
          ? data.aiDifficulty.value
          : this.aiDifficulty,
      aiRelatedConcepts: data.aiRelatedConcepts.present
          ? data.aiRelatedConcepts.value
          : this.aiRelatedConcepts,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      attachmentPaths: data.attachmentPaths.present
          ? data.attachmentPaths.value
          : this.attachmentPaths,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('aiTopics: $aiTopics, ')
          ..write('aiKeywords: $aiKeywords, ')
          ..write('aiDifficulty: $aiDifficulty, ')
          ..write('aiRelatedConcepts: $aiRelatedConcepts, ')
          ..write('sourceType: $sourceType, ')
          ..write('attachmentPaths: $attachmentPaths')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    content,
    category,
    createdAt,
    updatedAt,
    aiSummary,
    aiTopics,
    aiKeywords,
    aiDifficulty,
    aiRelatedConcepts,
    sourceType,
    attachmentPaths,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.category == this.category &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.aiSummary == this.aiSummary &&
          other.aiTopics == this.aiTopics &&
          other.aiKeywords == this.aiKeywords &&
          other.aiDifficulty == this.aiDifficulty &&
          other.aiRelatedConcepts == this.aiRelatedConcepts &&
          other.sourceType == this.sourceType &&
          other.attachmentPaths == this.attachmentPaths);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String> category;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> aiSummary;
  final Value<String?> aiTopics;
  final Value<String?> aiKeywords;
  final Value<String?> aiDifficulty;
  final Value<String?> aiRelatedConcepts;
  final Value<String> sourceType;
  final Value<String?> attachmentPaths;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.aiTopics = const Value.absent(),
    this.aiKeywords = const Value.absent(),
    this.aiDifficulty = const Value.absent(),
    this.aiRelatedConcepts = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.attachmentPaths = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String title,
    required String content,
    this.category = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.aiSummary = const Value.absent(),
    this.aiTopics = const Value.absent(),
    this.aiKeywords = const Value.absent(),
    this.aiDifficulty = const Value.absent(),
    this.aiRelatedConcepts = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.attachmentPaths = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? aiSummary,
    Expression<String>? aiTopics,
    Expression<String>? aiKeywords,
    Expression<String>? aiDifficulty,
    Expression<String>? aiRelatedConcepts,
    Expression<String>? sourceType,
    Expression<String>? attachmentPaths,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (aiSummary != null) 'ai_summary': aiSummary,
      if (aiTopics != null) 'ai_topics': aiTopics,
      if (aiKeywords != null) 'ai_keywords': aiKeywords,
      if (aiDifficulty != null) 'ai_difficulty': aiDifficulty,
      if (aiRelatedConcepts != null) 'ai_related_concepts': aiRelatedConcepts,
      if (sourceType != null) 'source_type': sourceType,
      if (attachmentPaths != null) 'attachment_paths': attachmentPaths,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? content,
    Value<String>? category,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? aiSummary,
    Value<String?>? aiTopics,
    Value<String?>? aiKeywords,
    Value<String?>? aiDifficulty,
    Value<String?>? aiRelatedConcepts,
    Value<String>? sourceType,
    Value<String?>? attachmentPaths,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      aiSummary: aiSummary ?? this.aiSummary,
      aiTopics: aiTopics ?? this.aiTopics,
      aiKeywords: aiKeywords ?? this.aiKeywords,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
      aiRelatedConcepts: aiRelatedConcepts ?? this.aiRelatedConcepts,
      sourceType: sourceType ?? this.sourceType,
      attachmentPaths: attachmentPaths ?? this.attachmentPaths,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (aiSummary.present) {
      map['ai_summary'] = Variable<String>(aiSummary.value);
    }
    if (aiTopics.present) {
      map['ai_topics'] = Variable<String>(aiTopics.value);
    }
    if (aiKeywords.present) {
      map['ai_keywords'] = Variable<String>(aiKeywords.value);
    }
    if (aiDifficulty.present) {
      map['ai_difficulty'] = Variable<String>(aiDifficulty.value);
    }
    if (aiRelatedConcepts.present) {
      map['ai_related_concepts'] = Variable<String>(aiRelatedConcepts.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (attachmentPaths.present) {
      map['attachment_paths'] = Variable<String>(attachmentPaths.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('aiTopics: $aiTopics, ')
          ..write('aiKeywords: $aiKeywords, ')
          ..write('aiDifficulty: $aiDifficulty, ')
          ..write('aiRelatedConcepts: $aiRelatedConcepts, ')
          ..write('sourceType: $sourceType, ')
          ..write('attachmentPaths: $attachmentPaths, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interestsMeta = const VerificationMeta(
    'interests',
  );
  @override
  late final GeneratedColumn<String> interests = GeneratedColumn<String>(
    'interests',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    bio,
    interests,
    imagePath,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('interests')) {
      context.handle(
        _interestsMeta,
        interests.isAcceptableOrUnknown(data['interests']!, _interestsMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      ),
      interests: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interests'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String name;
  final String? bio;
  final String? interests;
  final String? imagePath;
  final DateTime updatedAt;
  const Profile({
    required this.id,
    required this.name,
    this.bio,
    this.interests,
    this.imagePath,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || interests != null) {
      map['interests'] = Variable<String>(interests);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      interests: interests == null && nullToAbsent
          ? const Value.absent()
          : Value(interests),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      updatedAt: Value(updatedAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bio: serializer.fromJson<String?>(json['bio']),
      interests: serializer.fromJson<String?>(json['interests']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bio': serializer.toJson<String?>(bio),
      'interests': serializer.toJson<String?>(interests),
      'imagePath': serializer.toJson<String?>(imagePath),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Profile copyWith({
    int? id,
    String? name,
    Value<String?> bio = const Value.absent(),
    Value<String?> interests = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    DateTime? updatedAt,
  }) => Profile(
    id: id ?? this.id,
    name: name ?? this.name,
    bio: bio.present ? bio.value : this.bio,
    interests: interests.present ? interests.value : this.interests,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bio: data.bio.present ? data.bio.value : this.bio,
      interests: data.interests.present ? data.interests.value : this.interests,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('interests: $interests, ')
          ..write('imagePath: $imagePath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, bio, interests, imagePath, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.bio == this.bio &&
          other.interests == this.interests &&
          other.imagePath == this.imagePath &&
          other.updatedAt == this.updatedAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> bio;
  final Value<String?> interests;
  final Value<String?> imagePath;
  final Value<DateTime> updatedAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bio = const Value.absent(),
    this.interests = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bio = const Value.absent(),
    this.interests = const Value.absent(),
    this.imagePath = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bio,
    Expression<String>? interests,
    Expression<String>? imagePath,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bio != null) 'bio': bio,
      if (interests != null) 'interests': interests,
      if (imagePath != null) 'image_path': imagePath,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? bio,
    Value<String?>? interests,
    Value<String?>? imagePath,
    Value<DateTime>? updatedAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      imagePath: imagePath ?? this.imagePath,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (interests.present) {
      map['interests'] = Variable<String>(interests.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bio: $bio, ')
          ..write('interests: $interests, ')
          ..write('imagePath: $imagePath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NoteAttachmentsTable extends NoteAttachments
    with TableInfo<$NoteAttachmentsTable, NoteAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, noteId, path, type, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteAttachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteAttachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NoteAttachmentsTable createAlias(String alias) {
    return $NoteAttachmentsTable(attachedDatabase, alias);
  }
}

class NoteAttachment extends DataClass implements Insertable<NoteAttachment> {
  final String id;
  final String noteId;
  final String path;
  final String type;
  final DateTime createdAt;
  const NoteAttachment({
    required this.id,
    required this.noteId,
    required this.path,
    required this.type,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['note_id'] = Variable<String>(noteId);
    map['path'] = Variable<String>(path);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NoteAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return NoteAttachmentsCompanion(
      id: Value(id),
      noteId: Value(noteId),
      path: Value(path),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory NoteAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteAttachment(
      id: serializer.fromJson<String>(json['id']),
      noteId: serializer.fromJson<String>(json['noteId']),
      path: serializer.fromJson<String>(json['path']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'noteId': serializer.toJson<String>(noteId),
      'path': serializer.toJson<String>(path),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NoteAttachment copyWith({
    String? id,
    String? noteId,
    String? path,
    String? type,
    DateTime? createdAt,
  }) => NoteAttachment(
    id: id ?? this.id,
    noteId: noteId ?? this.noteId,
    path: path ?? this.path,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
  );
  NoteAttachment copyWithCompanion(NoteAttachmentsCompanion data) {
    return NoteAttachment(
      id: data.id.present ? data.id.value : this.id,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      path: data.path.present ? data.path.value : this.path,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteAttachment(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, noteId, path, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteAttachment &&
          other.id == this.id &&
          other.noteId == this.noteId &&
          other.path == this.path &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class NoteAttachmentsCompanion extends UpdateCompanion<NoteAttachment> {
  final Value<String> id;
  final Value<String> noteId;
  final Value<String> path;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NoteAttachmentsCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.path = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteAttachmentsCompanion.insert({
    required String id,
    required String noteId,
    required String path,
    required String type,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       noteId = Value(noteId),
       path = Value(path),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<NoteAttachment> custom({
    Expression<String>? id,
    Expression<String>? noteId,
    Expression<String>? path,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (path != null) 'path': path,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteAttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? noteId,
    Value<String>? path,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return NoteAttachmentsCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      path: path ?? this.path,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConceptsTable extends Concepts with TableInfo<$ConceptsTable, Concept> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConceptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiExplanationMeta = const VerificationMeta(
    'aiExplanation',
  );
  @override
  late final GeneratedColumn<String> aiExplanation = GeneratedColumn<String>(
    'ai_explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    description,
    aiExplanation,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'concepts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Concept> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('ai_explanation')) {
      context.handle(
        _aiExplanationMeta,
        aiExplanation.isAcceptableOrUnknown(
          data['ai_explanation']!,
          _aiExplanationMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Concept map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Concept(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      aiExplanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_explanation'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ConceptsTable createAlias(String alias) {
    return $ConceptsTable(attachedDatabase, alias);
  }
}

class Concept extends DataClass implements Insertable<Concept> {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String? aiExplanation;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Concept({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.aiExplanation,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || aiExplanation != null) {
      map['ai_explanation'] = Variable<String>(aiExplanation);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConceptsCompanion toCompanion(bool nullToAbsent) {
    return ConceptsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      aiExplanation: aiExplanation == null && nullToAbsent
          ? const Value.absent()
          : Value(aiExplanation),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Concept.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Concept(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      aiExplanation: serializer.fromJson<String?>(json['aiExplanation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'aiExplanation': serializer.toJson<String?>(aiExplanation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Concept copyWith({
    String? id,
    String? name,
    String? category,
    Value<String?> description = const Value.absent(),
    Value<String?> aiExplanation = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Concept(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    description: description.present ? description.value : this.description,
    aiExplanation: aiExplanation.present
        ? aiExplanation.value
        : this.aiExplanation,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Concept copyWithCompanion(ConceptsCompanion data) {
    return Concept(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      aiExplanation: data.aiExplanation.present
          ? data.aiExplanation.value
          : this.aiExplanation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Concept(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('aiExplanation: $aiExplanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    description,
    aiExplanation,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Concept &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.description == this.description &&
          other.aiExplanation == this.aiExplanation &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConceptsCompanion extends UpdateCompanion<Concept> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> description;
  final Value<String?> aiExplanation;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ConceptsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.aiExplanation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConceptsCompanion.insert({
    required String id,
    required String name,
    required String category,
    this.description = const Value.absent(),
    this.aiExplanation = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Concept> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? aiExplanation,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (aiExplanation != null) 'ai_explanation': aiExplanation,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConceptsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String?>? description,
    Value<String?>? aiExplanation,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ConceptsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      aiExplanation: aiExplanation ?? this.aiExplanation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (aiExplanation.present) {
      map['ai_explanation'] = Variable<String>(aiExplanation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConceptsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('aiExplanation: $aiExplanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteConceptsTable extends NoteConcepts
    with TableInfo<$NoteConceptsTable, NoteConcept> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteConceptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _conceptIdMeta = const VerificationMeta(
    'conceptId',
  );
  @override
  late final GeneratedColumn<String> conceptId = GeneratedColumn<String>(
    'concept_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES concepts (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, noteId, conceptId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_concepts';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteConcept> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('concept_id')) {
      context.handle(
        _conceptIdMeta,
        conceptId.isAcceptableOrUnknown(data['concept_id']!, _conceptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteConcept map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteConcept(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      conceptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept_id'],
      )!,
    );
  }

  @override
  $NoteConceptsTable createAlias(String alias) {
    return $NoteConceptsTable(attachedDatabase, alias);
  }
}

class NoteConcept extends DataClass implements Insertable<NoteConcept> {
  final int id;
  final String noteId;
  final String conceptId;
  const NoteConcept({
    required this.id,
    required this.noteId,
    required this.conceptId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note_id'] = Variable<String>(noteId);
    map['concept_id'] = Variable<String>(conceptId);
    return map;
  }

  NoteConceptsCompanion toCompanion(bool nullToAbsent) {
    return NoteConceptsCompanion(
      id: Value(id),
      noteId: Value(noteId),
      conceptId: Value(conceptId),
    );
  }

  factory NoteConcept.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteConcept(
      id: serializer.fromJson<int>(json['id']),
      noteId: serializer.fromJson<String>(json['noteId']),
      conceptId: serializer.fromJson<String>(json['conceptId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noteId': serializer.toJson<String>(noteId),
      'conceptId': serializer.toJson<String>(conceptId),
    };
  }

  NoteConcept copyWith({int? id, String? noteId, String? conceptId}) =>
      NoteConcept(
        id: id ?? this.id,
        noteId: noteId ?? this.noteId,
        conceptId: conceptId ?? this.conceptId,
      );
  NoteConcept copyWithCompanion(NoteConceptsCompanion data) {
    return NoteConcept(
      id: data.id.present ? data.id.value : this.id,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      conceptId: data.conceptId.present ? data.conceptId.value : this.conceptId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteConcept(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('conceptId: $conceptId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, noteId, conceptId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteConcept &&
          other.id == this.id &&
          other.noteId == this.noteId &&
          other.conceptId == this.conceptId);
}

class NoteConceptsCompanion extends UpdateCompanion<NoteConcept> {
  final Value<int> id;
  final Value<String> noteId;
  final Value<String> conceptId;
  const NoteConceptsCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.conceptId = const Value.absent(),
  });
  NoteConceptsCompanion.insert({
    this.id = const Value.absent(),
    required String noteId,
    required String conceptId,
  }) : noteId = Value(noteId),
       conceptId = Value(conceptId);
  static Insertable<NoteConcept> custom({
    Expression<int>? id,
    Expression<String>? noteId,
    Expression<String>? conceptId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (conceptId != null) 'concept_id': conceptId,
    });
  }

  NoteConceptsCompanion copyWith({
    Value<int>? id,
    Value<String>? noteId,
    Value<String>? conceptId,
  }) {
    return NoteConceptsCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      conceptId: conceptId ?? this.conceptId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (conceptId.present) {
      map['concept_id'] = Variable<String>(conceptId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteConceptsCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('conceptId: $conceptId')
          ..write(')'))
        .toString();
  }
}

class $ConceptRelationsTable extends ConceptRelations
    with TableInfo<$ConceptRelationsTable, ConceptRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConceptRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromConceptIdMeta = const VerificationMeta(
    'fromConceptId',
  );
  @override
  late final GeneratedColumn<String> fromConceptId = GeneratedColumn<String>(
    'from_concept_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES concepts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _toConceptIdMeta = const VerificationMeta(
    'toConceptId',
  );
  @override
  late final GeneratedColumn<String> toConceptId = GeneratedColumn<String>(
    'to_concept_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES concepts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relationTypeMeta = const VerificationMeta(
    'relationType',
  );
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
    'relation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('related'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromConceptId,
    toConceptId,
    relationType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'concept_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConceptRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_concept_id')) {
      context.handle(
        _fromConceptIdMeta,
        fromConceptId.isAcceptableOrUnknown(
          data['from_concept_id']!,
          _fromConceptIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromConceptIdMeta);
    }
    if (data.containsKey('to_concept_id')) {
      context.handle(
        _toConceptIdMeta,
        toConceptId.isAcceptableOrUnknown(
          data['to_concept_id']!,
          _toConceptIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toConceptIdMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
        _relationTypeMeta,
        relationType.isAcceptableOrUnknown(
          data['relation_type']!,
          _relationTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConceptRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConceptRelation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fromConceptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_concept_id'],
      )!,
      toConceptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_concept_id'],
      )!,
      relationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_type'],
      )!,
    );
  }

  @override
  $ConceptRelationsTable createAlias(String alias) {
    return $ConceptRelationsTable(attachedDatabase, alias);
  }
}

class ConceptRelation extends DataClass implements Insertable<ConceptRelation> {
  final int id;
  final String fromConceptId;
  final String toConceptId;
  final String relationType;
  const ConceptRelation({
    required this.id,
    required this.fromConceptId,
    required this.toConceptId,
    required this.relationType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_concept_id'] = Variable<String>(fromConceptId);
    map['to_concept_id'] = Variable<String>(toConceptId);
    map['relation_type'] = Variable<String>(relationType);
    return map;
  }

  ConceptRelationsCompanion toCompanion(bool nullToAbsent) {
    return ConceptRelationsCompanion(
      id: Value(id),
      fromConceptId: Value(fromConceptId),
      toConceptId: Value(toConceptId),
      relationType: Value(relationType),
    );
  }

  factory ConceptRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConceptRelation(
      id: serializer.fromJson<int>(json['id']),
      fromConceptId: serializer.fromJson<String>(json['fromConceptId']),
      toConceptId: serializer.fromJson<String>(json['toConceptId']),
      relationType: serializer.fromJson<String>(json['relationType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromConceptId': serializer.toJson<String>(fromConceptId),
      'toConceptId': serializer.toJson<String>(toConceptId),
      'relationType': serializer.toJson<String>(relationType),
    };
  }

  ConceptRelation copyWith({
    int? id,
    String? fromConceptId,
    String? toConceptId,
    String? relationType,
  }) => ConceptRelation(
    id: id ?? this.id,
    fromConceptId: fromConceptId ?? this.fromConceptId,
    toConceptId: toConceptId ?? this.toConceptId,
    relationType: relationType ?? this.relationType,
  );
  ConceptRelation copyWithCompanion(ConceptRelationsCompanion data) {
    return ConceptRelation(
      id: data.id.present ? data.id.value : this.id,
      fromConceptId: data.fromConceptId.present
          ? data.fromConceptId.value
          : this.fromConceptId,
      toConceptId: data.toConceptId.present
          ? data.toConceptId.value
          : this.toConceptId,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConceptRelation(')
          ..write('id: $id, ')
          ..write('fromConceptId: $fromConceptId, ')
          ..write('toConceptId: $toConceptId, ')
          ..write('relationType: $relationType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fromConceptId, toConceptId, relationType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConceptRelation &&
          other.id == this.id &&
          other.fromConceptId == this.fromConceptId &&
          other.toConceptId == this.toConceptId &&
          other.relationType == this.relationType);
}

class ConceptRelationsCompanion extends UpdateCompanion<ConceptRelation> {
  final Value<int> id;
  final Value<String> fromConceptId;
  final Value<String> toConceptId;
  final Value<String> relationType;
  const ConceptRelationsCompanion({
    this.id = const Value.absent(),
    this.fromConceptId = const Value.absent(),
    this.toConceptId = const Value.absent(),
    this.relationType = const Value.absent(),
  });
  ConceptRelationsCompanion.insert({
    this.id = const Value.absent(),
    required String fromConceptId,
    required String toConceptId,
    this.relationType = const Value.absent(),
  }) : fromConceptId = Value(fromConceptId),
       toConceptId = Value(toConceptId);
  static Insertable<ConceptRelation> custom({
    Expression<int>? id,
    Expression<String>? fromConceptId,
    Expression<String>? toConceptId,
    Expression<String>? relationType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromConceptId != null) 'from_concept_id': fromConceptId,
      if (toConceptId != null) 'to_concept_id': toConceptId,
      if (relationType != null) 'relation_type': relationType,
    });
  }

  ConceptRelationsCompanion copyWith({
    Value<int>? id,
    Value<String>? fromConceptId,
    Value<String>? toConceptId,
    Value<String>? relationType,
  }) {
    return ConceptRelationsCompanion(
      id: id ?? this.id,
      fromConceptId: fromConceptId ?? this.fromConceptId,
      toConceptId: toConceptId ?? this.toConceptId,
      relationType: relationType ?? this.relationType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromConceptId.present) {
      map['from_concept_id'] = Variable<String>(fromConceptId.value);
    }
    if (toConceptId.present) {
      map['to_concept_id'] = Variable<String>(toConceptId.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConceptRelationsCompanion(')
          ..write('id: $id, ')
          ..write('fromConceptId: $fromConceptId, ')
          ..write('toConceptId: $toConceptId, ')
          ..write('relationType: $relationType')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTable extends SearchHistory
    with TableInfo<$SearchHistoryTable, SearchHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, query, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<SearchHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('query')) {
      context.handle(
        _queryMeta,
        query.isAcceptableOrUnknown(data['query']!, _queryMeta),
      );
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      query: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SearchHistoryTable createAlias(String alias) {
    return $SearchHistoryTable(attachedDatabase, alias);
  }
}

class SearchHistoryData extends DataClass
    implements Insertable<SearchHistoryData> {
  final int id;
  final String query;
  final DateTime createdAt;
  const SearchHistoryData({
    required this.id,
    required this.query,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['query'] = Variable<String>(query);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SearchHistoryCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryCompanion(
      id: Value(id),
      query: Value(query),
      createdAt: Value(createdAt),
    );
  }

  factory SearchHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryData(
      id: serializer.fromJson<int>(json['id']),
      query: serializer.fromJson<String>(json['query']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'query': serializer.toJson<String>(query),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SearchHistoryData copyWith({int? id, String? query, DateTime? createdAt}) =>
      SearchHistoryData(
        id: id ?? this.id,
        query: query ?? this.query,
        createdAt: createdAt ?? this.createdAt,
      );
  SearchHistoryData copyWithCompanion(SearchHistoryCompanion data) {
    return SearchHistoryData(
      id: data.id.present ? data.id.value : this.id,
      query: data.query.present ? data.query.value : this.query,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryData(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, query, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryData &&
          other.id == this.id &&
          other.query == this.query &&
          other.createdAt == this.createdAt);
}

class SearchHistoryCompanion extends UpdateCompanion<SearchHistoryData> {
  final Value<int> id;
  final Value<String> query;
  final Value<DateTime> createdAt;
  const SearchHistoryCompanion({
    this.id = const Value.absent(),
    this.query = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SearchHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String query,
    required DateTime createdAt,
  }) : query = Value(query),
       createdAt = Value(createdAt);
  static Insertable<SearchHistoryData> custom({
    Expression<int>? id,
    Expression<String>? query,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (query != null) 'query': query,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SearchHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? query,
    Value<DateTime>? createdAt,
  }) {
    return SearchHistoryCompanion(
      id: id ?? this.id,
      query: query ?? this.query,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $QuizSessionsTable extends QuizSessions
    with TableInfo<$QuizSessionsTable, QuizSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteId,
    score,
    totalQuestions,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $QuizSessionsTable createAlias(String alias) {
    return $QuizSessionsTable(attachedDatabase, alias);
  }
}

class QuizSession extends DataClass implements Insertable<QuizSession> {
  final int id;
  final String noteId;
  final int score;
  final int totalQuestions;
  final DateTime createdAt;
  const QuizSession({
    required this.id,
    required this.noteId,
    required this.score,
    required this.totalQuestions,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note_id'] = Variable<String>(noteId);
    map['score'] = Variable<int>(score);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuizSessionsCompanion toCompanion(bool nullToAbsent) {
    return QuizSessionsCompanion(
      id: Value(id),
      noteId: Value(noteId),
      score: Value(score),
      totalQuestions: Value(totalQuestions),
      createdAt: Value(createdAt),
    );
  }

  factory QuizSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizSession(
      id: serializer.fromJson<int>(json['id']),
      noteId: serializer.fromJson<String>(json['noteId']),
      score: serializer.fromJson<int>(json['score']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noteId': serializer.toJson<String>(noteId),
      'score': serializer.toJson<int>(score),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  QuizSession copyWith({
    int? id,
    String? noteId,
    int? score,
    int? totalQuestions,
    DateTime? createdAt,
  }) => QuizSession(
    id: id ?? this.id,
    noteId: noteId ?? this.noteId,
    score: score ?? this.score,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    createdAt: createdAt ?? this.createdAt,
  );
  QuizSession copyWithCompanion(QuizSessionsCompanion data) {
    return QuizSession(
      id: data.id.present ? data.id.value : this.id,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      score: data.score.present ? data.score.value : this.score,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizSession(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, noteId, score, totalQuestions, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizSession &&
          other.id == this.id &&
          other.noteId == this.noteId &&
          other.score == this.score &&
          other.totalQuestions == this.totalQuestions &&
          other.createdAt == this.createdAt);
}

class QuizSessionsCompanion extends UpdateCompanion<QuizSession> {
  final Value<int> id;
  final Value<String> noteId;
  final Value<int> score;
  final Value<int> totalQuestions;
  final Value<DateTime> createdAt;
  const QuizSessionsCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.score = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  QuizSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String noteId,
    required int score,
    required int totalQuestions,
    required DateTime createdAt,
  }) : noteId = Value(noteId),
       score = Value(score),
       totalQuestions = Value(totalQuestions),
       createdAt = Value(createdAt);
  static Insertable<QuizSession> custom({
    Expression<int>? id,
    Expression<String>? noteId,
    Expression<int>? score,
    Expression<int>? totalQuestions,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (score != null) 'score': score,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  QuizSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? noteId,
    Value<int>? score,
    Value<int>? totalQuestions,
    Value<DateTime>? createdAt,
  }) {
    return QuizSessionsCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizSessionsCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FlashcardReviewsTable extends FlashcardReviews
    with TableInfo<$FlashcardReviewsTable, FlashcardReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _cardIndexMeta = const VerificationMeta(
    'cardIndex',
  );
  @override
  late final GeneratedColumn<int> cardIndex = GeneratedColumn<int>(
    'card_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteId,
    cardIndex,
    isCorrect,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcard_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlashcardReview> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('card_index')) {
      context.handle(
        _cardIndexMeta,
        cardIndex.isAcceptableOrUnknown(data['card_index']!, _cardIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIndexMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlashcardReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashcardReview(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      cardIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_index'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FlashcardReviewsTable createAlias(String alias) {
    return $FlashcardReviewsTable(attachedDatabase, alias);
  }
}

class FlashcardReview extends DataClass implements Insertable<FlashcardReview> {
  final int id;
  final String noteId;
  final int cardIndex;
  final bool isCorrect;
  final DateTime createdAt;
  const FlashcardReview({
    required this.id,
    required this.noteId,
    required this.cardIndex,
    required this.isCorrect,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['note_id'] = Variable<String>(noteId);
    map['card_index'] = Variable<int>(cardIndex);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FlashcardReviewsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardReviewsCompanion(
      id: Value(id),
      noteId: Value(noteId),
      cardIndex: Value(cardIndex),
      isCorrect: Value(isCorrect),
      createdAt: Value(createdAt),
    );
  }

  factory FlashcardReview.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashcardReview(
      id: serializer.fromJson<int>(json['id']),
      noteId: serializer.fromJson<String>(json['noteId']),
      cardIndex: serializer.fromJson<int>(json['cardIndex']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noteId': serializer.toJson<String>(noteId),
      'cardIndex': serializer.toJson<int>(cardIndex),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FlashcardReview copyWith({
    int? id,
    String? noteId,
    int? cardIndex,
    bool? isCorrect,
    DateTime? createdAt,
  }) => FlashcardReview(
    id: id ?? this.id,
    noteId: noteId ?? this.noteId,
    cardIndex: cardIndex ?? this.cardIndex,
    isCorrect: isCorrect ?? this.isCorrect,
    createdAt: createdAt ?? this.createdAt,
  );
  FlashcardReview copyWithCompanion(FlashcardReviewsCompanion data) {
    return FlashcardReview(
      id: data.id.present ? data.id.value : this.id,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      cardIndex: data.cardIndex.present ? data.cardIndex.value : this.cardIndex,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardReview(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('cardIndex: $cardIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, noteId, cardIndex, isCorrect, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashcardReview &&
          other.id == this.id &&
          other.noteId == this.noteId &&
          other.cardIndex == this.cardIndex &&
          other.isCorrect == this.isCorrect &&
          other.createdAt == this.createdAt);
}

class FlashcardReviewsCompanion extends UpdateCompanion<FlashcardReview> {
  final Value<int> id;
  final Value<String> noteId;
  final Value<int> cardIndex;
  final Value<bool> isCorrect;
  final Value<DateTime> createdAt;
  const FlashcardReviewsCompanion({
    this.id = const Value.absent(),
    this.noteId = const Value.absent(),
    this.cardIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FlashcardReviewsCompanion.insert({
    this.id = const Value.absent(),
    required String noteId,
    required int cardIndex,
    required bool isCorrect,
    required DateTime createdAt,
  }) : noteId = Value(noteId),
       cardIndex = Value(cardIndex),
       isCorrect = Value(isCorrect),
       createdAt = Value(createdAt);
  static Insertable<FlashcardReview> custom({
    Expression<int>? id,
    Expression<String>? noteId,
    Expression<int>? cardIndex,
    Expression<bool>? isCorrect,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      if (cardIndex != null) 'card_index': cardIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FlashcardReviewsCompanion copyWith({
    Value<int>? id,
    Value<String>? noteId,
    Value<int>? cardIndex,
    Value<bool>? isCorrect,
    Value<DateTime>? createdAt,
  }) {
    return FlashcardReviewsCompanion(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      cardIndex: cardIndex ?? this.cardIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (cardIndex.present) {
      map['card_index'] = Variable<int>(cardIndex.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardReviewsCompanion(')
          ..write('id: $id, ')
          ..write('noteId: $noteId, ')
          ..write('cardIndex: $cardIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentQasTable extends DocumentQas
    with TableInfo<$DocumentQasTable, DocumentQa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentQasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    question,
    answer,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_qas';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentQa> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentQa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentQa(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      ),
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DocumentQasTable createAlias(String alias) {
    return $DocumentQasTable(attachedDatabase, alias);
  }
}

class DocumentQa extends DataClass implements Insertable<DocumentQa> {
  final int id;
  final String? documentId;
  final String question;
  final String answer;
  final DateTime createdAt;
  const DocumentQa({
    required this.id,
    this.documentId,
    required this.question,
    required this.answer,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || documentId != null) {
      map['document_id'] = Variable<String>(documentId);
    }
    map['question'] = Variable<String>(question);
    map['answer'] = Variable<String>(answer);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocumentQasCompanion toCompanion(bool nullToAbsent) {
    return DocumentQasCompanion(
      id: Value(id),
      documentId: documentId == null && nullToAbsent
          ? const Value.absent()
          : Value(documentId),
      question: Value(question),
      answer: Value(answer),
      createdAt: Value(createdAt),
    );
  }

  factory DocumentQa.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentQa(
      id: serializer.fromJson<int>(json['id']),
      documentId: serializer.fromJson<String?>(json['documentId']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String>(json['answer']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentId': serializer.toJson<String?>(documentId),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String>(answer),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocumentQa copyWith({
    int? id,
    Value<String?> documentId = const Value.absent(),
    String? question,
    String? answer,
    DateTime? createdAt,
  }) => DocumentQa(
    id: id ?? this.id,
    documentId: documentId.present ? documentId.value : this.documentId,
    question: question ?? this.question,
    answer: answer ?? this.answer,
    createdAt: createdAt ?? this.createdAt,
  );
  DocumentQa copyWithCompanion(DocumentQasCompanion data) {
    return DocumentQa(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      question: data.question.present ? data.question.value : this.question,
      answer: data.answer.present ? data.answer.value : this.answer,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentQa(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, documentId, question, answer, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentQa &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.createdAt == this.createdAt);
}

class DocumentQasCompanion extends UpdateCompanion<DocumentQa> {
  final Value<int> id;
  final Value<String?> documentId;
  final Value<String> question;
  final Value<String> answer;
  final Value<DateTime> createdAt;
  const DocumentQasCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DocumentQasCompanion.insert({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    required String question,
    required String answer,
    required DateTime createdAt,
  }) : question = Value(question),
       answer = Value(answer),
       createdAt = Value(createdAt);
  static Insertable<DocumentQa> custom({
    Expression<int>? id,
    Expression<String>? documentId,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DocumentQasCompanion copyWith({
    Value<int>? id,
    Value<String?>? documentId,
    Value<String>? question,
    Value<String>? answer,
    Value<DateTime>? createdAt,
  }) {
    return DocumentQasCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentQasCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $NoteAttachmentsTable noteAttachments = $NoteAttachmentsTable(
    this,
  );
  late final $ConceptsTable concepts = $ConceptsTable(this);
  late final $NoteConceptsTable noteConcepts = $NoteConceptsTable(this);
  late final $ConceptRelationsTable conceptRelations = $ConceptRelationsTable(
    this,
  );
  late final $SearchHistoryTable searchHistory = $SearchHistoryTable(this);
  late final $QuizSessionsTable quizSessions = $QuizSessionsTable(this);
  late final $FlashcardReviewsTable flashcardReviews = $FlashcardReviewsTable(
    this,
  );
  late final $DocumentQasTable documentQas = $DocumentQasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    notes,
    profiles,
    noteAttachments,
    concepts,
    noteConcepts,
    conceptRelations,
    searchHistory,
    quizSessions,
    flashcardReviews,
    documentQas,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('note_concepts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'concepts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('note_concepts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'concepts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('concept_relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'concepts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('concept_relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('flashcard_reviews', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      required String id,
      required String title,
      required String content,
      Value<String> category,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> aiSummary,
      Value<String?> aiTopics,
      Value<String?> aiKeywords,
      Value<String?> aiDifficulty,
      Value<String?> aiRelatedConcepts,
      Value<String> sourceType,
      Value<String?> attachmentPaths,
      Value<int> rowid,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> content,
      Value<String> category,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> aiSummary,
      Value<String?> aiTopics,
      Value<String?> aiKeywords,
      Value<String?> aiDifficulty,
      Value<String?> aiRelatedConcepts,
      Value<String> sourceType,
      Value<String?> attachmentPaths,
      Value<int> rowid,
    });

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, Note> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$NoteConceptsTable, List<NoteConcept>>
  _noteConceptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.noteConcepts,
    aliasName: 'notes__id__note_concepts__note_id',
  );

  $$NoteConceptsTableProcessedTableManager get noteConceptsRefs {
    final manager = $$NoteConceptsTableTableManager(
      $_db,
      $_db.noteConcepts,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteConceptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizSessionsTable, List<QuizSession>>
  _quizSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizSessions,
    aliasName: 'notes__id__quiz_sessions__note_id',
  );

  $$QuizSessionsTableProcessedTableManager get quizSessionsRefs {
    final manager = $$QuizSessionsTableTableManager(
      $_db,
      $_db.quizSessions,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FlashcardReviewsTable, List<FlashcardReview>>
  _flashcardReviewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flashcardReviews,
    aliasName: 'notes__id__flashcard_reviews__note_id',
  );

  $$FlashcardReviewsTableProcessedTableManager get flashcardReviewsRefs {
    final manager = $$FlashcardReviewsTableTableManager(
      $_db,
      $_db.flashcardReviews,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _flashcardReviewsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiTopics => $composableBuilder(
    column: $table.aiTopics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiKeywords => $composableBuilder(
    column: $table.aiKeywords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiDifficulty => $composableBuilder(
    column: $table.aiDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiRelatedConcepts => $composableBuilder(
    column: $table.aiRelatedConcepts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachmentPaths => $composableBuilder(
    column: $table.attachmentPaths,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> noteConceptsRefs(
    Expression<bool> Function($$NoteConceptsTableFilterComposer f) f,
  ) {
    final $$NoteConceptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteConcepts,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteConceptsTableFilterComposer(
            $db: $db,
            $table: $db.noteConcepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizSessionsRefs(
    Expression<bool> Function($$QuizSessionsTableFilterComposer f) f,
  ) {
    final $$QuizSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizSessions,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizSessionsTableFilterComposer(
            $db: $db,
            $table: $db.quizSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> flashcardReviewsRefs(
    Expression<bool> Function($$FlashcardReviewsTableFilterComposer f) f,
  ) {
    final $$FlashcardReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardReviews,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardReviewsTableFilterComposer(
            $db: $db,
            $table: $db.flashcardReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiTopics => $composableBuilder(
    column: $table.aiTopics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiKeywords => $composableBuilder(
    column: $table.aiKeywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiDifficulty => $composableBuilder(
    column: $table.aiDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiRelatedConcepts => $composableBuilder(
    column: $table.aiRelatedConcepts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachmentPaths => $composableBuilder(
    column: $table.attachmentPaths,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get aiSummary =>
      $composableBuilder(column: $table.aiSummary, builder: (column) => column);

  GeneratedColumn<String> get aiTopics =>
      $composableBuilder(column: $table.aiTopics, builder: (column) => column);

  GeneratedColumn<String> get aiKeywords => $composableBuilder(
    column: $table.aiKeywords,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiDifficulty => $composableBuilder(
    column: $table.aiDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiRelatedConcepts => $composableBuilder(
    column: $table.aiRelatedConcepts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attachmentPaths => $composableBuilder(
    column: $table.attachmentPaths,
    builder: (column) => column,
  );

  Expression<T> noteConceptsRefs<T extends Object>(
    Expression<T> Function($$NoteConceptsTableAnnotationComposer a) f,
  ) {
    final $$NoteConceptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteConcepts,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteConceptsTableAnnotationComposer(
            $db: $db,
            $table: $db.noteConcepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizSessionsRefs<T extends Object>(
    Expression<T> Function($$QuizSessionsTableAnnotationComposer a) f,
  ) {
    final $$QuizSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizSessions,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> flashcardReviewsRefs<T extends Object>(
    Expression<T> Function($$FlashcardReviewsTableAnnotationComposer a) f,
  ) {
    final $$FlashcardReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flashcardReviews,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlashcardReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.flashcardReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, $$NotesTableReferences),
          Note,
          PrefetchHooks Function({
            bool noteConceptsRefs,
            bool quizSessionsRefs,
            bool flashcardReviewsRefs,
          })
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> aiSummary = const Value.absent(),
                Value<String?> aiTopics = const Value.absent(),
                Value<String?> aiKeywords = const Value.absent(),
                Value<String?> aiDifficulty = const Value.absent(),
                Value<String?> aiRelatedConcepts = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> attachmentPaths = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                title: title,
                content: content,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                aiSummary: aiSummary,
                aiTopics: aiTopics,
                aiKeywords: aiKeywords,
                aiDifficulty: aiDifficulty,
                aiRelatedConcepts: aiRelatedConcepts,
                sourceType: sourceType,
                attachmentPaths: attachmentPaths,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String content,
                Value<String> category = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> aiSummary = const Value.absent(),
                Value<String?> aiTopics = const Value.absent(),
                Value<String?> aiKeywords = const Value.absent(),
                Value<String?> aiDifficulty = const Value.absent(),
                Value<String?> aiRelatedConcepts = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> attachmentPaths = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                title: title,
                content: content,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                aiSummary: aiSummary,
                aiTopics: aiTopics,
                aiKeywords: aiKeywords,
                aiDifficulty: aiDifficulty,
                aiRelatedConcepts: aiRelatedConcepts,
                sourceType: sourceType,
                attachmentPaths: attachmentPaths,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                noteConceptsRefs = false,
                quizSessionsRefs = false,
                flashcardReviewsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (noteConceptsRefs) db.noteConcepts,
                    if (quizSessionsRefs) db.quizSessions,
                    if (flashcardReviewsRefs) db.flashcardReviews,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (noteConceptsRefs)
                        await $_getPrefetchedData<
                          Note,
                          $NotesTable,
                          NoteConcept
                        >(
                          currentTable: table,
                          referencedTable: $$NotesTableReferences
                              ._noteConceptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NotesTableReferences(
                                db,
                                table,
                                p0,
                              ).noteConceptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizSessionsRefs)
                        await $_getPrefetchedData<
                          Note,
                          $NotesTable,
                          QuizSession
                        >(
                          currentTable: table,
                          referencedTable: $$NotesTableReferences
                              ._quizSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NotesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (flashcardReviewsRefs)
                        await $_getPrefetchedData<
                          Note,
                          $NotesTable,
                          FlashcardReview
                        >(
                          currentTable: table,
                          referencedTable: $$NotesTableReferences
                              ._flashcardReviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NotesTableReferences(
                                db,
                                table,
                                p0,
                              ).flashcardReviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, $$NotesTableReferences),
      Note,
      PrefetchHooks Function({
        bool noteConceptsRefs,
        bool quizSessionsRefs,
        bool flashcardReviewsRefs,
      })
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> bio,
      Value<String?> interests,
      Value<String?> imagePath,
      required DateTime updatedAt,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> bio,
      Value<String?> interests,
      Value<String?> imagePath,
      Value<DateTime> updatedAt,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interests => $composableBuilder(
    column: $table.interests,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interests => $composableBuilder(
    column: $table.interests,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get interests =>
      $composableBuilder(column: $table.interests, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> interests = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                bio: bio,
                interests: interests,
                imagePath: imagePath,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> bio = const Value.absent(),
                Value<String?> interests = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required DateTime updatedAt,
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                bio: bio,
                interests: interests,
                imagePath: imagePath,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$NoteAttachmentsTableCreateCompanionBuilder =
    NoteAttachmentsCompanion Function({
      required String id,
      required String noteId,
      required String path,
      required String type,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$NoteAttachmentsTableUpdateCompanionBuilder =
    NoteAttachmentsCompanion Function({
      Value<String> id,
      Value<String> noteId,
      Value<String> path,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$NoteAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteAttachmentsTable> {
  $$NoteAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoteAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteAttachmentsTable> {
  $$NoteAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteId => $composableBuilder(
    column: $table.noteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteAttachmentsTable> {
  $$NoteAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noteId =>
      $composableBuilder(column: $table.noteId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NoteAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteAttachmentsTable,
          NoteAttachment,
          $$NoteAttachmentsTableFilterComposer,
          $$NoteAttachmentsTableOrderingComposer,
          $$NoteAttachmentsTableAnnotationComposer,
          $$NoteAttachmentsTableCreateCompanionBuilder,
          $$NoteAttachmentsTableUpdateCompanionBuilder,
          (
            NoteAttachment,
            BaseReferences<
              _$AppDatabase,
              $NoteAttachmentsTable,
              NoteAttachment
            >,
          ),
          NoteAttachment,
          PrefetchHooks Function()
        > {
  $$NoteAttachmentsTableTableManager(
    _$AppDatabase db,
    $NoteAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> noteId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteAttachmentsCompanion(
                id: id,
                noteId: noteId,
                path: path,
                type: type,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String noteId,
                required String path,
                required String type,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => NoteAttachmentsCompanion.insert(
                id: id,
                noteId: noteId,
                path: path,
                type: type,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteAttachmentsTable,
      NoteAttachment,
      $$NoteAttachmentsTableFilterComposer,
      $$NoteAttachmentsTableOrderingComposer,
      $$NoteAttachmentsTableAnnotationComposer,
      $$NoteAttachmentsTableCreateCompanionBuilder,
      $$NoteAttachmentsTableUpdateCompanionBuilder,
      (
        NoteAttachment,
        BaseReferences<_$AppDatabase, $NoteAttachmentsTable, NoteAttachment>,
      ),
      NoteAttachment,
      PrefetchHooks Function()
    >;
typedef $$ConceptsTableCreateCompanionBuilder =
    ConceptsCompanion Function({
      required String id,
      required String name,
      required String category,
      Value<String?> description,
      Value<String?> aiExplanation,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ConceptsTableUpdateCompanionBuilder =
    ConceptsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<String?> description,
      Value<String?> aiExplanation,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ConceptsTableReferences
    extends BaseReferences<_$AppDatabase, $ConceptsTable, Concept> {
  $$ConceptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$NoteConceptsTable, List<NoteConcept>>
  _noteConceptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.noteConcepts,
    aliasName: 'concepts__id__note_concepts__concept_id',
  );

  $$NoteConceptsTableProcessedTableManager get noteConceptsRefs {
    final manager = $$NoteConceptsTableTableManager(
      $_db,
      $_db.noteConcepts,
    ).filter((f) => f.conceptId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteConceptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ConceptsTableFilterComposer
    extends Composer<_$AppDatabase, $ConceptsTable> {
  $$ConceptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiExplanation => $composableBuilder(
    column: $table.aiExplanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> noteConceptsRefs(
    Expression<bool> Function($$NoteConceptsTableFilterComposer f) f,
  ) {
    final $$NoteConceptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteConcepts,
      getReferencedColumn: (t) => t.conceptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteConceptsTableFilterComposer(
            $db: $db,
            $table: $db.noteConcepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ConceptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConceptsTable> {
  $$ConceptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiExplanation => $composableBuilder(
    column: $table.aiExplanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConceptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConceptsTable> {
  $$ConceptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiExplanation => $composableBuilder(
    column: $table.aiExplanation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> noteConceptsRefs<T extends Object>(
    Expression<T> Function($$NoteConceptsTableAnnotationComposer a) f,
  ) {
    final $$NoteConceptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteConcepts,
      getReferencedColumn: (t) => t.conceptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteConceptsTableAnnotationComposer(
            $db: $db,
            $table: $db.noteConcepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ConceptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConceptsTable,
          Concept,
          $$ConceptsTableFilterComposer,
          $$ConceptsTableOrderingComposer,
          $$ConceptsTableAnnotationComposer,
          $$ConceptsTableCreateCompanionBuilder,
          $$ConceptsTableUpdateCompanionBuilder,
          (Concept, $$ConceptsTableReferences),
          Concept,
          PrefetchHooks Function({bool noteConceptsRefs})
        > {
  $$ConceptsTableTableManager(_$AppDatabase db, $ConceptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConceptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConceptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConceptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> aiExplanation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConceptsCompanion(
                id: id,
                name: name,
                category: category,
                description: description,
                aiExplanation: aiExplanation,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                Value<String?> description = const Value.absent(),
                Value<String?> aiExplanation = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ConceptsCompanion.insert(
                id: id,
                name: name,
                category: category,
                description: description,
                aiExplanation: aiExplanation,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ConceptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteConceptsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (noteConceptsRefs) db.noteConcepts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (noteConceptsRefs)
                    await $_getPrefetchedData<
                      Concept,
                      $ConceptsTable,
                      NoteConcept
                    >(
                      currentTable: table,
                      referencedTable: $$ConceptsTableReferences
                          ._noteConceptsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ConceptsTableReferences(
                        db,
                        table,
                        p0,
                      ).noteConceptsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.conceptId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ConceptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConceptsTable,
      Concept,
      $$ConceptsTableFilterComposer,
      $$ConceptsTableOrderingComposer,
      $$ConceptsTableAnnotationComposer,
      $$ConceptsTableCreateCompanionBuilder,
      $$ConceptsTableUpdateCompanionBuilder,
      (Concept, $$ConceptsTableReferences),
      Concept,
      PrefetchHooks Function({bool noteConceptsRefs})
    >;
typedef $$NoteConceptsTableCreateCompanionBuilder =
    NoteConceptsCompanion Function({
      Value<int> id,
      required String noteId,
      required String conceptId,
    });
typedef $$NoteConceptsTableUpdateCompanionBuilder =
    NoteConceptsCompanion Function({
      Value<int> id,
      Value<String> noteId,
      Value<String> conceptId,
    });

final class $$NoteConceptsTableReferences
    extends BaseReferences<_$AppDatabase, $NoteConceptsTable, NoteConcept> {
  $$NoteConceptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) =>
      db.notes.createAlias('note_concepts__note_id__notes__id');

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ConceptsTable _conceptIdTable(_$AppDatabase db) =>
      db.concepts.createAlias('note_concepts__concept_id__concepts__id');

  $$ConceptsTableProcessedTableManager get conceptId {
    final $_column = $_itemColumn<String>('concept_id')!;

    final manager = $$ConceptsTableTableManager(
      $_db,
      $_db.concepts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conceptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NoteConceptsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteConceptsTable> {
  $$NoteConceptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ConceptsTableFilterComposer get conceptId {
    final $$ConceptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableFilterComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteConceptsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteConceptsTable> {
  $$NoteConceptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ConceptsTableOrderingComposer get conceptId {
    final $$ConceptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableOrderingComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteConceptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteConceptsTable> {
  $$NoteConceptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ConceptsTableAnnotationComposer get conceptId {
    final $$ConceptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableAnnotationComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteConceptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteConceptsTable,
          NoteConcept,
          $$NoteConceptsTableFilterComposer,
          $$NoteConceptsTableOrderingComposer,
          $$NoteConceptsTableAnnotationComposer,
          $$NoteConceptsTableCreateCompanionBuilder,
          $$NoteConceptsTableUpdateCompanionBuilder,
          (NoteConcept, $$NoteConceptsTableReferences),
          NoteConcept,
          PrefetchHooks Function({bool noteId, bool conceptId})
        > {
  $$NoteConceptsTableTableManager(_$AppDatabase db, $NoteConceptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteConceptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteConceptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteConceptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> noteId = const Value.absent(),
                Value<String> conceptId = const Value.absent(),
              }) => NoteConceptsCompanion(
                id: id,
                noteId: noteId,
                conceptId: conceptId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String noteId,
                required String conceptId,
              }) => NoteConceptsCompanion.insert(
                id: id,
                noteId: noteId,
                conceptId: conceptId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NoteConceptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false, conceptId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable: $$NoteConceptsTableReferences
                                    ._noteIdTable(db),
                                referencedColumn: $$NoteConceptsTableReferences
                                    ._noteIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (conceptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.conceptId,
                                referencedTable: $$NoteConceptsTableReferences
                                    ._conceptIdTable(db),
                                referencedColumn: $$NoteConceptsTableReferences
                                    ._conceptIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NoteConceptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteConceptsTable,
      NoteConcept,
      $$NoteConceptsTableFilterComposer,
      $$NoteConceptsTableOrderingComposer,
      $$NoteConceptsTableAnnotationComposer,
      $$NoteConceptsTableCreateCompanionBuilder,
      $$NoteConceptsTableUpdateCompanionBuilder,
      (NoteConcept, $$NoteConceptsTableReferences),
      NoteConcept,
      PrefetchHooks Function({bool noteId, bool conceptId})
    >;
typedef $$ConceptRelationsTableCreateCompanionBuilder =
    ConceptRelationsCompanion Function({
      Value<int> id,
      required String fromConceptId,
      required String toConceptId,
      Value<String> relationType,
    });
typedef $$ConceptRelationsTableUpdateCompanionBuilder =
    ConceptRelationsCompanion Function({
      Value<int> id,
      Value<String> fromConceptId,
      Value<String> toConceptId,
      Value<String> relationType,
    });

final class $$ConceptRelationsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ConceptRelationsTable, ConceptRelation> {
  $$ConceptRelationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ConceptsTable _fromConceptIdTable(_$AppDatabase db) => db.concepts
      .createAlias('concept_relations__from_concept_id__concepts__id');

  $$ConceptsTableProcessedTableManager get fromConceptId {
    final $_column = $_itemColumn<String>('from_concept_id')!;

    final manager = $$ConceptsTableTableManager(
      $_db,
      $_db.concepts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromConceptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ConceptsTable _toConceptIdTable(_$AppDatabase db) =>
      db.concepts.createAlias('concept_relations__to_concept_id__concepts__id');

  $$ConceptsTableProcessedTableManager get toConceptId {
    final $_column = $_itemColumn<String>('to_concept_id')!;

    final manager = $$ConceptsTableTableManager(
      $_db,
      $_db.concepts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toConceptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConceptRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $ConceptRelationsTable> {
  $$ConceptRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnFilters(column),
  );

  $$ConceptsTableFilterComposer get fromConceptId {
    final $$ConceptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromConceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableFilterComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ConceptsTableFilterComposer get toConceptId {
    final $$ConceptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toConceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableFilterComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConceptRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConceptRelationsTable> {
  $$ConceptRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnOrderings(column),
  );

  $$ConceptsTableOrderingComposer get fromConceptId {
    final $$ConceptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromConceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableOrderingComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ConceptsTableOrderingComposer get toConceptId {
    final $$ConceptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toConceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableOrderingComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConceptRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConceptRelationsTable> {
  $$ConceptRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => column,
  );

  $$ConceptsTableAnnotationComposer get fromConceptId {
    final $$ConceptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromConceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableAnnotationComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ConceptsTableAnnotationComposer get toConceptId {
    final $$ConceptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toConceptId,
      referencedTable: $db.concepts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConceptsTableAnnotationComposer(
            $db: $db,
            $table: $db.concepts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConceptRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConceptRelationsTable,
          ConceptRelation,
          $$ConceptRelationsTableFilterComposer,
          $$ConceptRelationsTableOrderingComposer,
          $$ConceptRelationsTableAnnotationComposer,
          $$ConceptRelationsTableCreateCompanionBuilder,
          $$ConceptRelationsTableUpdateCompanionBuilder,
          (ConceptRelation, $$ConceptRelationsTableReferences),
          ConceptRelation,
          PrefetchHooks Function({bool fromConceptId, bool toConceptId})
        > {
  $$ConceptRelationsTableTableManager(
    _$AppDatabase db,
    $ConceptRelationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConceptRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConceptRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConceptRelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fromConceptId = const Value.absent(),
                Value<String> toConceptId = const Value.absent(),
                Value<String> relationType = const Value.absent(),
              }) => ConceptRelationsCompanion(
                id: id,
                fromConceptId: fromConceptId,
                toConceptId: toConceptId,
                relationType: relationType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fromConceptId,
                required String toConceptId,
                Value<String> relationType = const Value.absent(),
              }) => ConceptRelationsCompanion.insert(
                id: id,
                fromConceptId: fromConceptId,
                toConceptId: toConceptId,
                relationType: relationType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ConceptRelationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fromConceptId = false, toConceptId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (fromConceptId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fromConceptId,
                                    referencedTable:
                                        $$ConceptRelationsTableReferences
                                            ._fromConceptIdTable(db),
                                    referencedColumn:
                                        $$ConceptRelationsTableReferences
                                            ._fromConceptIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (toConceptId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.toConceptId,
                                    referencedTable:
                                        $$ConceptRelationsTableReferences
                                            ._toConceptIdTable(db),
                                    referencedColumn:
                                        $$ConceptRelationsTableReferences
                                            ._toConceptIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ConceptRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConceptRelationsTable,
      ConceptRelation,
      $$ConceptRelationsTableFilterComposer,
      $$ConceptRelationsTableOrderingComposer,
      $$ConceptRelationsTableAnnotationComposer,
      $$ConceptRelationsTableCreateCompanionBuilder,
      $$ConceptRelationsTableUpdateCompanionBuilder,
      (ConceptRelation, $$ConceptRelationsTableReferences),
      ConceptRelation,
      PrefetchHooks Function({bool fromConceptId, bool toConceptId})
    >;
typedef $$SearchHistoryTableCreateCompanionBuilder =
    SearchHistoryCompanion Function({
      Value<int> id,
      required String query,
      required DateTime createdAt,
    });
typedef $$SearchHistoryTableUpdateCompanionBuilder =
    SearchHistoryCompanion Function({
      Value<int> id,
      Value<String> query,
      Value<DateTime> createdAt,
    });

class $$SearchHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SearchHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SearchHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SearchHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchHistoryTable,
          SearchHistoryData,
          $$SearchHistoryTableFilterComposer,
          $$SearchHistoryTableOrderingComposer,
          $$SearchHistoryTableAnnotationComposer,
          $$SearchHistoryTableCreateCompanionBuilder,
          $$SearchHistoryTableUpdateCompanionBuilder,
          (
            SearchHistoryData,
            BaseReferences<
              _$AppDatabase,
              $SearchHistoryTable,
              SearchHistoryData
            >,
          ),
          SearchHistoryData,
          PrefetchHooks Function()
        > {
  $$SearchHistoryTableTableManager(_$AppDatabase db, $SearchHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> query = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SearchHistoryCompanion(
                id: id,
                query: query,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String query,
                required DateTime createdAt,
              }) => SearchHistoryCompanion.insert(
                id: id,
                query: query,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchHistoryTable,
      SearchHistoryData,
      $$SearchHistoryTableFilterComposer,
      $$SearchHistoryTableOrderingComposer,
      $$SearchHistoryTableAnnotationComposer,
      $$SearchHistoryTableCreateCompanionBuilder,
      $$SearchHistoryTableUpdateCompanionBuilder,
      (
        SearchHistoryData,
        BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>,
      ),
      SearchHistoryData,
      PrefetchHooks Function()
    >;
typedef $$QuizSessionsTableCreateCompanionBuilder =
    QuizSessionsCompanion Function({
      Value<int> id,
      required String noteId,
      required int score,
      required int totalQuestions,
      required DateTime createdAt,
    });
typedef $$QuizSessionsTableUpdateCompanionBuilder =
    QuizSessionsCompanion Function({
      Value<int> id,
      Value<String> noteId,
      Value<int> score,
      Value<int> totalQuestions,
      Value<DateTime> createdAt,
    });

final class $$QuizSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizSessionsTable, QuizSession> {
  $$QuizSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotesTable _noteIdTable(_$AppDatabase db) =>
      db.notes.createAlias('quiz_sessions__note_id__notes__id');

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizSessionsTable> {
  $$QuizSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizSessionsTable> {
  $$QuizSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizSessionsTable> {
  $$QuizSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizSessionsTable,
          QuizSession,
          $$QuizSessionsTableFilterComposer,
          $$QuizSessionsTableOrderingComposer,
          $$QuizSessionsTableAnnotationComposer,
          $$QuizSessionsTableCreateCompanionBuilder,
          $$QuizSessionsTableUpdateCompanionBuilder,
          (QuizSession, $$QuizSessionsTableReferences),
          QuizSession,
          PrefetchHooks Function({bool noteId})
        > {
  $$QuizSessionsTableTableManager(_$AppDatabase db, $QuizSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> noteId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => QuizSessionsCompanion(
                id: id,
                noteId: noteId,
                score: score,
                totalQuestions: totalQuestions,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String noteId,
                required int score,
                required int totalQuestions,
                required DateTime createdAt,
              }) => QuizSessionsCompanion.insert(
                id: id,
                noteId: noteId,
                score: score,
                totalQuestions: totalQuestions,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable: $$QuizSessionsTableReferences
                                    ._noteIdTable(db),
                                referencedColumn: $$QuizSessionsTableReferences
                                    ._noteIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizSessionsTable,
      QuizSession,
      $$QuizSessionsTableFilterComposer,
      $$QuizSessionsTableOrderingComposer,
      $$QuizSessionsTableAnnotationComposer,
      $$QuizSessionsTableCreateCompanionBuilder,
      $$QuizSessionsTableUpdateCompanionBuilder,
      (QuizSession, $$QuizSessionsTableReferences),
      QuizSession,
      PrefetchHooks Function({bool noteId})
    >;
typedef $$FlashcardReviewsTableCreateCompanionBuilder =
    FlashcardReviewsCompanion Function({
      Value<int> id,
      required String noteId,
      required int cardIndex,
      required bool isCorrect,
      required DateTime createdAt,
    });
typedef $$FlashcardReviewsTableUpdateCompanionBuilder =
    FlashcardReviewsCompanion Function({
      Value<int> id,
      Value<String> noteId,
      Value<int> cardIndex,
      Value<bool> isCorrect,
      Value<DateTime> createdAt,
    });

final class $$FlashcardReviewsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FlashcardReviewsTable, FlashcardReview> {
  $$FlashcardReviewsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NotesTable _noteIdTable(_$AppDatabase db) =>
      db.notes.createAlias('flashcard_reviews__note_id__notes__id');

  $$NotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FlashcardReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardReviewsTable> {
  $$FlashcardReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardIndex => $composableBuilder(
    column: $table.cardIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotesTableFilterComposer get noteId {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardReviewsTable> {
  $$FlashcardReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardIndex => $composableBuilder(
    column: $table.cardIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotesTableOrderingComposer get noteId {
    final $$NotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableOrderingComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardReviewsTable> {
  $$FlashcardReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cardIndex =>
      $composableBuilder(column: $table.cardIndex, builder: (column) => column);

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$NotesTableAnnotationComposer get noteId {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlashcardReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardReviewsTable,
          FlashcardReview,
          $$FlashcardReviewsTableFilterComposer,
          $$FlashcardReviewsTableOrderingComposer,
          $$FlashcardReviewsTableAnnotationComposer,
          $$FlashcardReviewsTableCreateCompanionBuilder,
          $$FlashcardReviewsTableUpdateCompanionBuilder,
          (FlashcardReview, $$FlashcardReviewsTableReferences),
          FlashcardReview,
          PrefetchHooks Function({bool noteId})
        > {
  $$FlashcardReviewsTableTableManager(
    _$AppDatabase db,
    $FlashcardReviewsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> noteId = const Value.absent(),
                Value<int> cardIndex = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FlashcardReviewsCompanion(
                id: id,
                noteId: noteId,
                cardIndex: cardIndex,
                isCorrect: isCorrect,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String noteId,
                required int cardIndex,
                required bool isCorrect,
                required DateTime createdAt,
              }) => FlashcardReviewsCompanion.insert(
                id: id,
                noteId: noteId,
                cardIndex: cardIndex,
                isCorrect: isCorrect,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FlashcardReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable:
                                    $$FlashcardReviewsTableReferences
                                        ._noteIdTable(db),
                                referencedColumn:
                                    $$FlashcardReviewsTableReferences
                                        ._noteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FlashcardReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardReviewsTable,
      FlashcardReview,
      $$FlashcardReviewsTableFilterComposer,
      $$FlashcardReviewsTableOrderingComposer,
      $$FlashcardReviewsTableAnnotationComposer,
      $$FlashcardReviewsTableCreateCompanionBuilder,
      $$FlashcardReviewsTableUpdateCompanionBuilder,
      (FlashcardReview, $$FlashcardReviewsTableReferences),
      FlashcardReview,
      PrefetchHooks Function({bool noteId})
    >;
typedef $$DocumentQasTableCreateCompanionBuilder =
    DocumentQasCompanion Function({
      Value<int> id,
      Value<String?> documentId,
      required String question,
      required String answer,
      required DateTime createdAt,
    });
typedef $$DocumentQasTableUpdateCompanionBuilder =
    DocumentQasCompanion Function({
      Value<int> id,
      Value<String?> documentId,
      Value<String> question,
      Value<String> answer,
      Value<DateTime> createdAt,
    });

class $$DocumentQasTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentQasTable> {
  $$DocumentQasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentQasTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentQasTable> {
  $$DocumentQasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentQasTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentQasTable> {
  $$DocumentQasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DocumentQasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentQasTable,
          DocumentQa,
          $$DocumentQasTableFilterComposer,
          $$DocumentQasTableOrderingComposer,
          $$DocumentQasTableAnnotationComposer,
          $$DocumentQasTableCreateCompanionBuilder,
          $$DocumentQasTableUpdateCompanionBuilder,
          (
            DocumentQa,
            BaseReferences<_$AppDatabase, $DocumentQasTable, DocumentQa>,
          ),
          DocumentQa,
          PrefetchHooks Function()
        > {
  $$DocumentQasTableTableManager(_$AppDatabase db, $DocumentQasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentQasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentQasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentQasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> documentId = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DocumentQasCompanion(
                id: id,
                documentId: documentId,
                question: question,
                answer: answer,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> documentId = const Value.absent(),
                required String question,
                required String answer,
                required DateTime createdAt,
              }) => DocumentQasCompanion.insert(
                id: id,
                documentId: documentId,
                question: question,
                answer: answer,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentQasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentQasTable,
      DocumentQa,
      $$DocumentQasTableFilterComposer,
      $$DocumentQasTableOrderingComposer,
      $$DocumentQasTableAnnotationComposer,
      $$DocumentQasTableCreateCompanionBuilder,
      $$DocumentQasTableUpdateCompanionBuilder,
      (
        DocumentQa,
        BaseReferences<_$AppDatabase, $DocumentQasTable, DocumentQa>,
      ),
      DocumentQa,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$NoteAttachmentsTableTableManager get noteAttachments =>
      $$NoteAttachmentsTableTableManager(_db, _db.noteAttachments);
  $$ConceptsTableTableManager get concepts =>
      $$ConceptsTableTableManager(_db, _db.concepts);
  $$NoteConceptsTableTableManager get noteConcepts =>
      $$NoteConceptsTableTableManager(_db, _db.noteConcepts);
  $$ConceptRelationsTableTableManager get conceptRelations =>
      $$ConceptRelationsTableTableManager(_db, _db.conceptRelations);
  $$SearchHistoryTableTableManager get searchHistory =>
      $$SearchHistoryTableTableManager(_db, _db.searchHistory);
  $$QuizSessionsTableTableManager get quizSessions =>
      $$QuizSessionsTableTableManager(_db, _db.quizSessions);
  $$FlashcardReviewsTableTableManager get flashcardReviews =>
      $$FlashcardReviewsTableTableManager(_db, _db.flashcardReviews);
  $$DocumentQasTableTableManager get documentQas =>
      $$DocumentQasTableTableManager(_db, _db.documentQas);
}
