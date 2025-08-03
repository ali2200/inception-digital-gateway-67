-- Create tables for website content management

-- Services table
CREATE TABLE public.services (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  content TEXT,
  icon TEXT,
  image_url TEXT,
  slug TEXT UNIQUE,
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Articles table
CREATE TABLE public.articles (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT,
  excerpt TEXT,
  image_url TEXT,
  slug TEXT UNIQUE,
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  author TEXT,
  views INTEGER DEFAULT 0,
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Books table
CREATE TABLE public.books (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  author TEXT,
  image_url TEXT,
  amazon_link TEXT,
  price DECIMAL(10,2),
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Testimonials table
CREATE TABLE public.testimonials (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  content TEXT NOT NULL,
  image_url TEXT,
  company TEXT,
  position TEXT,
  rating INTEGER DEFAULT 5 CHECK (rating >= 1 AND rating <= 5),
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Industries table
CREATE TABLE public.industries (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  content TEXT,
  image_url TEXT,
  slug TEXT UNIQUE,
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Contact forms table
CREATE TABLE public.contact_forms (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  subject TEXT,
  message TEXT NOT NULL,
  status TEXT DEFAULT 'unread' CHECK (status IN ('unread', 'read', 'replied')),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.industries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contact_forms ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
CREATE POLICY "Services are publicly readable" ON public.services FOR SELECT USING (true);
CREATE POLICY "Articles are publicly readable" ON public.articles FOR SELECT USING (status = 'published');
CREATE POLICY "Books are publicly readable" ON public.books FOR SELECT USING (true);
CREATE POLICY "Testimonials are publicly readable" ON public.testimonials FOR SELECT USING (true);
CREATE POLICY "Industries are publicly readable" ON public.industries FOR SELECT USING (true);

-- Create policies for admin management (will need authentication later)
CREATE POLICY "Admin can manage services" ON public.services FOR ALL USING (true);
CREATE POLICY "Admin can manage articles" ON public.articles FOR ALL USING (true);
CREATE POLICY "Admin can manage books" ON public.books FOR ALL USING (true);
CREATE POLICY "Admin can manage testimonials" ON public.testimonials FOR ALL USING (true);
CREATE POLICY "Admin can manage industries" ON public.industries FOR ALL USING (true);
CREATE POLICY "Admin can manage contact forms" ON public.contact_forms FOR ALL USING (true);

-- Create function to update timestamps
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for automatic timestamp updates
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_articles_updated_at BEFORE UPDATE ON public.articles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_books_updated_at BEFORE UPDATE ON public.books FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_testimonials_updated_at BEFORE UPDATE ON public.testimonials FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_industries_updated_at BEFORE UPDATE ON public.industries FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Insert sample data
INSERT INTO public.services (title, description, content, icon, slug, featured) VALUES
('خدمات SEO', 'تحسين محركات البحث لموقعك', 'محتوى تفصيلي عن خدمات SEO...', 'Search', 'seo-services', true),
('إدارة وسائل التواصل الاجتماعي', 'إدارة حساباتك على منصات التواصل', 'محتوى تفصيلي عن إدارة السوشيال ميديا...', 'Share2', 'social-media-management', true),
('الإعلانات المدفوعة', 'حملات إعلانية فعالة ومربحة', 'محتوى تفصيلي عن الإعلانات المدفوعة...', 'Target', 'paid-ads', true),
('تطوير المواقع', 'تصميم وتطوير مواقع احترافية', 'محتوى تفصيلي عن تطوير المواقع...', 'Code', 'web-development', true),
('إنتاج المحتوى', 'إنتاج محتوى إبداعي وجذاب', 'محتوى تفصيلي عن إنتاج المحتوى...', 'Camera', 'media-production', true);

INSERT INTO public.articles (title, content, excerpt, slug, status, author, featured) VALUES
('أساسيات تحسين محركات البحث', 'محتوى تفصيلي عن SEO...', 'تعلم أساسيات SEO لتحسين ترتيب موقعك', 'seo-basics', 'published', 'أحمد محمد', true),
('استراتيجيات التسويق الرقمي', 'محتوى تفصيلي عن التسويق الرقمي...', 'استراتيجيات مجربة في التسويق الرقمي', 'digital-marketing-strategies', 'published', 'سارة أحمد', true);

INSERT INTO public.testimonials (name, content, company, position, rating, featured) VALUES
('أحمد محمد', 'خدمة ممتازة وفريق محترف جداً. ساعدوني في تطوير موقعي بشكل رائع.', 'شركة التقنية المتقدمة', 'مدير التسويق', 5, true),
('سارة علي', 'النتائج فاقت توقعاتي. زادت مبيعاتي بنسبة 200% بعد حملة التسويق.', 'متجر الأزياء العصرية', 'صاحبة المتجر', 5, true);

INSERT INTO public.industries (title, description, content, slug, featured) VALUES
('التجارة الإلكترونية', 'حلول تسويقية متخصصة للمتاجر الإلكترونية', 'محتوى تفصيلي عن التجارة الإلكترونية...', 'ecommerce', true),
('الخدمات الطبية', 'تسويق رقمي للعيادات والمستشفيات', 'محتوى تفصيلي عن الخدمات الطبية...', 'healthcare', true),
('التعليم والتدريب', 'حلول تسويقية للمؤسسات التعليمية', 'محتوى تفصيلي عن التعليم...', 'education', true);