#ifndef LAYOUTPARSER_H
#define LAYOUTPARSER_H

#include <QString>
#include <QXmlStreamReader>
#include "Components/SplitLayoutParsing/splitlayout.h"

class LayoutParser
{
public:
    static SplitLayout* readLayout(const QString& path);

private:
    // <-- Parsers -->

    // Parser for the main layout tag (<Run>)
    static void parseRun(QXmlStreamReader* xmlReader, SplitLayout* splitLayout);
    // Parser for the <Metadata> layout tag inside <Run>
    static void parseMetadata(QXmlStreamReader* xmlReader, SplitLayout* splitLayout);
    // Parser for the <AttemptHistory> layout tag inside <Run>
    static void parseAttemptHistory(QXmlStreamReader* xmlReader, SplitLayout* splitLayout);
    // Parser for the <Attempt> layout tag inside <AttemptHistory>
    static void parseAttempt(QXmlStreamReader* xmlReader, SplitLayout* splitLayout);
    // Parser for the <Segments> layout tag inside <Run>
    static void parseSegments(QXmlStreamReader* xmlReader, SplitLayout* splitLayout);
    // Parser for the <Segment> layout tag inside <Segments>
    static void parseSegment(QXmlStreamReader* xmlReader, SplitLayout* splitLayout);
    // Parser for the <SplitTimes> layout tag inside <Segment>
    static void parseSplitTimes(QXmlStreamReader* xmlReader, SplitSegment& splitSegment);
    // Parser for <GameTime> and <RealTime> layout tag
    static void parseSegmentTime(QXmlStreamReader* xmlReader, QList<TimeMethod> times, const QString endTagName);
    // Parser for the <SegmentHistory> layout tag inside <Segment>
    static void parseSegmentHistory(QXmlStreamReader* xmlReader, SplitSegment& splitSegment);

    // <-- XML Property/Attribute Readers -->

    static void readStringProperty(QString& splitVar, QXmlStreamReader* xmlReader);
    static void readIntProperty(int& splitVar, QXmlStreamReader* xmlReader);
    static void readAttributeProperty(const QString& attributeName, QString& splitVar, QXmlStreamReader* xmlReader);
};

#endif // LAYOUTPARSER_H
