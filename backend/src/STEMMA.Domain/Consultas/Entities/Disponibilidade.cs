using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Domain.Consultas.Entities;

public class Disponibilidade
{
    public Guid Id { get; private set; }

    public Guid VeterinarioId { get; private set; }
    
    public Veterinario? Veterinario { get; private set; }

    public DateTime DataInicio { get; private set; }

    public DateTime DataFim { get; private set; }

    protected Disponibilidade() { }

    public Disponibilidade(
        Guid veterinarioId,
        DateTime dataInicio,
        DateTime dataFim)
    {
        Validar(veterinarioId, dataInicio, dataFim);

        Id = Guid.NewGuid();
        VeterinarioId = veterinarioId;
        DataInicio = dataInicio;
        DataFim = dataFim;
    }

    private void Validar(
        Guid veterinarioId,
        DateTime dataInicio,
        DateTime dataFim)
    {
        if (veterinarioId == Guid.Empty)
            throw new ArgumentException("Veterinário obrigatório.");

        if (dataFim <= dataInicio)
            throw new ArgumentException("Data final deve ser maior que a inicial.");

        if (dataInicio < DateTime.UtcNow)
            throw new ArgumentException("Data inicial inválida.");
    }

    public bool ConflitaCom(DateTime inicio, DateTime fim)
    {
        return inicio < DataFim && fim > DataInicio;
    }

    
}