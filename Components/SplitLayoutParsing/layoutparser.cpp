#include "layoutparser.h"

#include <QFile>
#include <QDebug>



SplitLayout* LayoutParser::readLayout(const QString& path) {

    QFile file = QFile(path);

    if (!file.open(QIODeviceBase::ReadOnly)) {
        qDebug() << "Unable to open layout file for parsing: " << path << Qt::endl;
        return nullptr;
    }

    qDebug() << "Layout file at:" << path << " read successfully." << Qt::endl;

    QXmlStreamReader xmlReader = QXmlStreamReader(file.readAll());

    qDebug() << "XML Data read successfully!" << Qt::endl;

    SplitLayout* splitLayout = new SplitLayout();

    while (!xmlReader.atEnd() && !xmlReader.hasError()) {
        QXmlStreamReader::TokenType token = xmlReader.readNext();

        if (token == QXmlStreamReader::StartDocument) continue;

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader.name(), "Run", Qt::CaseInsensitive) == 0) {
                qDebug() << "<-- XML Layout Start -->" << Qt::endl;
                parseRun(&xmlReader, splitLayout);
                //qDebug() << xmlReader.attributes().value("Run").toString();
            }
        }
    }

    return splitLayout;
}

void LayoutParser::parseRun(QXmlStreamReader* xmlReader, SplitLayout* splitLayout) {
    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            // Game Icon
            if (QString::compare(xmlReader->name(), "GameIcon", Qt::CaseInsensitive) == 0) {
                readStringProperty(splitLayout->gameIcon, xmlReader);
            }
            // Game Name
            else if (QString::compare(xmlReader->name(), "GameName", Qt::CaseInsensitive) == 0) {
                readStringProperty(splitLayout->gameName, xmlReader);
                qDebug() << "Read Game Name: " << splitLayout->gameName << xmlReader->name() <<  Qt::endl;
            }
            // Category Name
            else if (QString::compare(xmlReader->name(), "CategoryName", Qt::CaseInsensitive) == 0) {
                readStringProperty(splitLayout->categoryName, xmlReader);
                qDebug() << "Read Category Name:" << splitLayout->categoryName << xmlReader->name() << Qt::endl;
            }
            // Metadata
            else if (QString::compare(xmlReader->name(), "Metadata", Qt::CaseInsensitive) == 0) {
                parseMetadata(xmlReader, splitLayout);
            }
            // Offset
            else if (QString::compare(xmlReader->name(), "Offset", Qt::CaseInsensitive) == 0) {
                readStringProperty(splitLayout->offset, xmlReader);
            }
            // AttemptCount
            else if (QString::compare(xmlReader->name(), "AttemptCount", Qt::CaseInsensitive) == 0) {
                readIntProperty(splitLayout->attemptCount, xmlReader);
                qDebug() << "Read Attempt Count:" << splitLayout->attemptCount << xmlReader->name() << Qt::endl;
            }
            // Attempt History
            else if (QString::compare(xmlReader->name(), "AttemptHistory", Qt::CaseInsensitive) == 0) {
                parseAttemptHistory(xmlReader, splitLayout);
            }
            // Segments
            else if (QString::compare(xmlReader->name(), "Segments", Qt::CaseInsensitive) == 0) {
                parseSegments(xmlReader, splitLayout);
            }

        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), "Run", Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }
}

void LayoutParser::parseMetadata(QXmlStreamReader* xmlReader, SplitLayout* splitLayout) {
    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader->name(), "Run", Qt::CaseInsensitive) == 0) {
                readAttributeProperty("Run", splitLayout->metadata.runId, xmlReader);
                qDebug() << "Read Metadata Run Attribute:" << splitLayout->metadata.runId << xmlReader->name() << Qt::endl;
            }
            else if (QString::compare(xmlReader->name(), "Platform", Qt::CaseInsensitive) == 0) {
                readAttributeProperty("usesEmulator", splitLayout->metadata.platform.usesEmulator, xmlReader);
                readStringProperty(splitLayout->metadata.platform.platform, xmlReader);
                qDebug() << "Read Metadata Platform: UsesEmulator?" << splitLayout->metadata.platform.usesEmulator << "Extra Platform Info:" << splitLayout->metadata.platform.platform << xmlReader->name() << Qt::endl;
            }
            else if (QString::compare(xmlReader->name(), "Region", Qt::CaseInsensitive) == 0) {
                readStringProperty(splitLayout->metadata.region, xmlReader);
            }
        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), "Metadata", Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }
}

void LayoutParser::parseAttemptHistory(QXmlStreamReader* xmlReader, SplitLayout* splitLayout) {
    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader->name(), "Attempt", Qt::CaseInsensitive) == 0) {
                parseAttempt(xmlReader, splitLayout);
            }
        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), "AttemptHistory", Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }
}

void LayoutParser::parseAttempt(QXmlStreamReader* xmlReader, SplitLayout* splitLayout) {
    SplitAttempt splitAttempt = SplitAttempt();

    // Read Attribute Properties
    readAttributeProperty("id", splitAttempt.id, xmlReader);
    readAttributeProperty("started", splitAttempt.started, xmlReader);
    readAttributeProperty("isStartedSynced", splitAttempt.isStartedSynced, xmlReader);
    readAttributeProperty("ended", splitAttempt.ended, xmlReader);
    readAttributeProperty("isEndedSynced", splitAttempt.isEndedSynced, xmlReader);

    // Loop to look for the <PauseTime> tag. There should only be one of these tags, but looping here
    // in case there is some formatting issue.
    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader->name(), "PauseHistory", Qt::CaseInsensitive) == 0) {
                readStringProperty(splitAttempt.pauseTime, xmlReader);
            }
        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), "Attempt", Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }

    // Add the split attempt to the attempt history.
    splitLayout->attemptHistory.push_back(splitAttempt);
    qDebug() << "Added to AttemptHistory:" << splitAttempt.id << splitAttempt.started << splitAttempt.isStartedSynced
             << splitAttempt.ended << splitAttempt.isEndedSynced << splitAttempt.pauseTime << Qt::endl;
}

void LayoutParser::parseSegments(QXmlStreamReader* xmlReader, SplitLayout* splitLayout) {
    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader->name(), "Segment", Qt::CaseInsensitive) == 0) {
                parseSegment(xmlReader, splitLayout);
            }
        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), "Segments", Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }
}

void LayoutParser::parseSegment(QXmlStreamReader* xmlReader, SplitLayout* splitLayout) {
    SplitSegment* segment = new SplitSegment();

    qDebug() << "Parse Segment!";

    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader->name(), "Name", Qt::CaseInsensitive) == 0) {
                readStringProperty(segment->name, xmlReader);
            }
            else if (QString::compare(xmlReader->name(), "SplitTimes", Qt::CaseInsensitive) == 0) {
                parseSplitTimes(xmlReader, *segment);
            }
            else if (QString::compare(xmlReader->name(), "BestSegmentTime", Qt::CaseInsensitive) == 0) {
                parseSegmentTime(xmlReader, segment->bestSegmentTime, "BestSegmentTime");
            }
            else if (QString::compare(xmlReader->name(), "SegmentHistory", Qt::CaseInsensitive) == 0) {
                parseSegmentHistory(xmlReader, *segment);
            }
        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), "Segment", Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }
    splitLayout->segments.append(segment);
}

void LayoutParser::parseSplitTimes(QXmlStreamReader* xmlReader, SplitSegment& splitSegment) {
    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader->name(), "SplitTime", Qt::CaseInsensitive) == 0) {
                SplitTime splitTime;
                readAttributeProperty("name", splitTime.name, xmlReader);
                splitSegment.splitTimes.push_back(splitTime);
            }
        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), "SplitTimes", Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }
}

void LayoutParser::parseSegmentTime(QXmlStreamReader* xmlReader, QList<TimeMethod> times, const QString endTagName) {
    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader->name(), "RealTime", Qt::CaseInsensitive) == 0) {
                TimeMethod time;
                time.type = RealTime;
                readStringProperty(time.time, xmlReader);
                times.push_back(time);
            }
            else if (QString::compare(xmlReader->name(), "GameTime", Qt::CaseInsensitive) == 0) {
                TimeMethod time;
                time.type = GameTime;
                readStringProperty(time.time, xmlReader);
                times.push_back(time);
            }
        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), endTagName, Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }
}

void LayoutParser::parseSegmentHistory(QXmlStreamReader* xmlReader, SplitSegment& splitSegment) {
    while (!xmlReader->atEnd() && !xmlReader->hasError()) {
        QXmlStreamReader::TokenType token = xmlReader->readNext();

        if (token == QXmlStreamReader::StartElement) {
            if (QString::compare(xmlReader->name(), "Time", Qt::CaseInsensitive) == 0) {
                SegmentTime time;
                readAttributeProperty("id", time.id, xmlReader);
                parseSegmentTime(xmlReader, time.times, "Time");
                splitSegment.segmentHistory.push_back(time);
            }
        }
        else if (token == QXmlStreamReader::EndElement) {
            if (QString::compare(xmlReader->name(), "SegmentHistory", Qt::CaseInsensitive) == 0) {
                break;
            }
        }
    }
}

void LayoutParser::readStringProperty(QString& splitVar, QXmlStreamReader* xmlReader) {
    splitVar = xmlReader->readElementText().trimmed();
}

void LayoutParser::readIntProperty(int& splitVar, QXmlStreamReader* xmlReader) {
    splitVar = xmlReader->readElementText().trimmed().toInt();
}

void LayoutParser::readAttributeProperty(const QString& attributeName, QString& splitVar, QXmlStreamReader* xmlReader) {
    splitVar = xmlReader->attributes().value(attributeName).toString();
}
